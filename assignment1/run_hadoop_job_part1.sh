#!/bin/bash

# Redirect all output to a log file and save the name with today's date as may 02 2022
exec > >(tee -i cmd_part1_$(date '+%Y-%m-%d').log)
exec 2>&1

# Define HDFS input path
hdfs_input="/Input/access.log"

# Ask the user which reducer to run
read -p "Enter 1 for reducer1(Get top 3 ip from each hour) or 2 for reducer2(Get top 3 ip from all hours): " reducer_choice

# Define HDFS output path based on the reducer choice
if [ $reducer_choice -eq 1 ]; then
    hdfs_output="/assignment1/Part_01/Output_For_Reduce_reducer1"
elif [ $reducer_choice -eq 2 ]; then
    hdfs_output="/assignment1/Part_01/Output_For_Reduce_reducer2"
else
    echo "Invalid choice. Exiting..."
    exit 1
fi

# Check if the output directory exists, delete it if it does
hdfs dfs -test -d $hdfs_output
if [ $? -eq 0 ]; then
    echo "Deleting existing output directory: $hdfs_output"
    hdfs dfs -rm -r $hdfs_output
fi

# Run the Hadoop streaming job based on the reducer choice
echo "Running reducer$reducer_choice"
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-3.3.6.jar \
    -mapper "/usr/bin/python3 /home/hadoop/ECC_Spring_2024/assignment1/Part_01/mapper.py" \
    -reducer "/usr/bin/python3 /home/hadoop/ECC_Spring_2024/assignment1/Part_01/reducer$reducer_choice.py" \
    -input $hdfs_input \
    -output $hdfs_output

echo "Job completed. Output stored in: $hdfs_output"


#store the hdfs output to local file system in a text file
hdfs dfs -cat $hdfs_output/part-00000 > /home/hadoop/output_part1_$(date '+%Y-%m-%d').txt

echo "Output stored in local file system: /home/hadoop/output_part1_$(date '+%Y-%m-%d').txt"
