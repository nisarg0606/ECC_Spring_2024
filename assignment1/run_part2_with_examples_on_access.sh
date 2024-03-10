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

# Check if the output directory exists, delete it if it does
hdfs dfs -test -d $hdfs_output_part2
if [ $? -eq 0 ]; then
    echo "Deleting existing output directory: $hdfs_output_part2"
    hdfs dfs -rm -r $hdfs_output_part2
fi

# Check if the output directory exists, delete it if it does
hdfs dfs -test -d $hdfs_output_wordcount
if [ $? -eq 0 ]; then
    echo "Deleting existing output directory: $hdfs_output_wordcount"
    hdfs dfs -rm -r $hdfs_output_wordcount
fi

# Check if the output directory exists, delete it if it does
hdfs dfs -test -d $hdfs_output_grep
if [ $? -eq 0 ]; then
    echo "Deleting existing output directory: $hdfs_output_grep"
    hdfs dfs -rm -r $hdfs_output_grep
fi

# Check if the output directory exists, delete it if it does
hdfs dfs -test -d $hdfs_output_sort
if [ $? -eq 0 ]; then
    echo "Deleting existing output directory: $hdfs_output_sort"
    hdfs dfs -rm -r $hdfs_output_sort
fi

# Run the Hadoop streaming job
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-3.3.6.jar \
    -D mapreduce.job.name="Part 02 - Access Log" \
    -D mapreduce.job.reuse.jvm.num.tasks=4 \
    -D mapreduce.job.maps=4 \
    -D mapreduce.job.reduces=1 \
    -mapper "/usr/bin/python3 /home/hadoop/ECC_Spring_2024/assignment1/Part_02/mapper.py" \
    -reducer "/usr/bin/python3 /home/hadoop/ECC_Spring_2024/assignment1/Part_02/reducer.py $start_time-$end_time" \
    -input $hdfs_input \
    -output $hdfs_output_part2 &

# Run the Hadoop streaming job for WordCount
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-3.3.6.jar \
    -D mapreduce.job.name="WordCount Example" \
    -D mapreduce.job.reuse.jvm.num.tasks=4 \
    -D mapreduce.job.maps=4 \
    -D mapreduce.job.reduces=1 \
    -mapper "/usr/bin/python3 /home/hadoop/ECC_Spring_2024/assignment1/Examples/WordCount/mapper.py" \
    -reducer "/usr/bin/python3 /home/hadoop/ECC_Spring_2024/assignment1/WordCount/reducer.py" \
    -input $hdfs_input \
    -output $hdfs_output_wordcount &

# Run the Hadoop streaming job for Grep
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-3.3.6.jar \
    -D mapreduce.job.name="Grep Example" \
    -D mapreduce.job.reuse.jvm.num.tasks=4 \
    -D mapreduce.job.maps=4 \
    -D mapreduce.job.reduces=1 \
    -mapper "/usr/bin/python3 /home/hadoop/ECC_Spring_2024/assignment1/Examples/Grep/mapper.py $pattern" \
    -reducer "/usr/bin/python3 /home/hadoop/ECC_Spring_2024/assignment1/Examples/Grep/reducer.py" \
    -input $hdfs_input \
    -output $hdfs_output_grep &

# Run the Hadoop streaming job for Sort
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-3.3.6.jar \
    -D mapreduce.job.name="Sort Example" \
    -D mapreduce.job.reuse.jvm.num.tasks=4 \
    -D mapreduce.job.maps=4 \
    -D mapreduce.job.reduces=1 \
    -mapper "/usr/bin/python3 /home/hadoop/ECC_Spring_2024/assignment1/Examples/Sort/mapper.py" \
    -reducer "/usr/bin/python3 /home/hadoop/ECC_Spring_2024/assignment1/Examples/Sort/reducer.py" \
    -input $hdfs_input \
    -output $hdfs_output_sort &

wait

echo "Job completed. Output stored in: $hdfs_output_part2, $hdfs_output_wordcount, $hdfs_output_grep, $hdfs_output_sort"