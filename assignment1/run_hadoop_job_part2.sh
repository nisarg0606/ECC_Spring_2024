#!/bin/bash

# Redirect all output to a log file
exec > >(tee -i cmd_part2_$(date '+%Y-%m-%d').log)
exec 2>&1

# Ask the user for start and end times
read -p "Enter the start time (format HH): " start_time
read -p "Enter the end time (format HH): " end_time

# Define HDFS input and output paths
hdfs_input="/Input/access.log"
hdfs_output="/assignment1/Part_02_Output_access_${start_time}_${end_time}"

# Check if the output directory exists, delete it if it does
hdfs dfs -test -d $hdfs_output
if [ $? -eq 0 ]; then
    echo "Deleting existing output directory: $hdfs_output"
    hdfs dfs -rm -r $hdfs_output
fi

# Run the Hadoop streaming job
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-3.3.6.jar \
    -D mapreduce.job.name="Part 02 - Access Log" \
    -D mapreduce.job.reuse.jvm.num.tasks=4 \
    -D mapreduce.job.maps=4 \
    -D mapreduce.job.reduces=4 \
    -mapper "/usr/bin/python3 /home/hadoop/ECC_Spring_2024/assignment1/Part_02/mapper.py" \
    -reducer "/usr/bin/python3 /home/hadoop/ECC_Spring_2024/assignment1/Part_02/reducer.py $start_time-$end_time" \
    -input $hdfs_input \
    -output $hdfs_output

echo "Job completed. Output stored in: $hdfs_output"

# Store the HDFS output to local file system in a text file
hdfs dfs -cat $hdfs_output/part-00000 > /home/hadoop/ECC_Spring_2024/assignment1/output_part2_${start_time}_${end_time}_$(date '+%Y-%m-%d').txt

echo "Output stored in local file system: /home/hadoop/ECC_Spring_2024/assignment1/output_part2_${start_time}_${end_time}_$(date '+%Y-%m-%d').txt"

