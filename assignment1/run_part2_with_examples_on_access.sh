#!/bin/bash

# Redirect all output to a log file
exec > >(tee -i cmd_part2_$(date '+%Y-%m-%d').log)
exec 2>&1

# Ask the user for start and end times
read -p "Enter the start time (format HH): " start_time
read -p "Enter the end time (format HH): " end_time
read -p "Enter the pattern to search for grep: " pattern

# Define HDFS input and output paths
hdfs_input="/Input/access.log"
hdfs_output_part2="/assignment1/Part_02_Output_access_${start_time}_${end_time}"
hdfs_output_wordcount="/assignment1/WordCount_Output/wc_output_$(date '+%Y-%m-%d-%H-%M')"
hdfs_output_grep="/assignment1/Grep_Output/grep_output_$(date '+%Y-%m-%d-%H-%M')"
hdfs_output_sort="/assignment1/Sort_Output/sort_output_$(date '+%Y-%m-%d-%H-%M')"

# Function to delete existing HDFS directory
delete_hdfs_dir() {
    hdfs dfs -test -d $1
    if [ $? -eq 0 ]; then
        echo "Deleting existing output directory: $1"
        hdfs dfs -rm -r $1
    fi
}

# Delete existing HDFS directories
delete_hdfs_dir $hdfs_output_part2
delete_hdfs_dir $hdfs_output_wordcount
delete_hdfs_dir $hdfs_output_grep
delete_hdfs_dir $hdfs_output_sort

# Define Hadoop jobs
declare -A jobs
jobs["Part 02 - Access Log"]="-mapper \"/usr/bin/python3 /home/hadoop/ECC_Spring_2024/assignment1/Part_02/mapper.py\" -reducer \"/usr/bin/python3 /home/hadoop/ECC_Spring_2024/assignment1/Part_02/reducer.py $start_time-$end_time\" -output $hdfs_output_part2"
jobs["WordCount Example"]="-mapper \"/usr/bin/python3 /home/hadoop/ECC_Spring_2024/assignment1/Examples/WordCount/mapper.py\" -reducer \"/usr/bin/python3 /home/hadoop/ECC_Spring_2024/assignment1/WordCount/reducer.py\" -output $hdfs_output_wordcount"
jobs["Grep Example"]="-mapper \"/usr/bin/python3 /home/hadoop/ECC_Spring_2024/assignment1/Examples/Grep/mapper.py $pattern\" -reducer \"/usr/bin/python3 /home/hadoop/ECC_Spring_2024/assignment1/Examples/Grep/reducer.py\" -output $hdfs_output_grep"
jobs["Sort Example"]="-mapper \"/usr/bin/python3 /home/hadoop/ECC_Spring_2024/assignment1/Examples/Sort/mapper.py\" -reducer \"/usr/bin/python3 /home/hadoop/ECC_Spring_2024/assignment1/Examples/Sort/reducer.py\" -output $hdfs_output_sort"

# Run the Hadoop jobs
for job in "${!jobs[@]}"; do
    hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-3.3.6.jar \
        -D mapreduce.job.name="$job" \
        -D mapreduce.job.reuse.jvm.num.tasks=4 \
        -D mapreduce.job.maps=4 \
        -D mapreduce.job.reduces=1 \
        -input $hdfs_input \
        ${jobs[$job]} &
done

# Wait for all jobs to complete
wait

echo "All jobs completed."