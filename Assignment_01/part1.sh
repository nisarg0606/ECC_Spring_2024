#!/bin/bash

# Define HDFS input and output paths
hdfs_input="/Assignment_01/Input/access.log"
hdfs_output="/Assignment_01/Part_01/output/$(date +'%d-%B-%Y-%H-%M-%S')"

# Check if the output directory exists, delete it if it does
hdfs dfs -test -d $hdfs_output
if [ $? -eq 0 ]; then
    echo "Deleting existing output directory: $hdfs_output"
    hdfs dfs -rm -r $hdfs_output
fi

# Ask the user for map and reduce scripts
echo "Which mapper and reducer scripts would you like to use?"
echo "Enter 1 for mapper1.py and reducer1.py"
echo "Enter 2 for mapper2.py and reducer2.py"
read choice

# Set mapper and reducer scripts based on user input
if [ $choice -eq 1 ]; then
    mapper_script="/home/hadoop/Assignment_01/Part_01/mapper1.py"
    reducer_script="/home/hadoop/Assignment_01/Part_01/reducer1.py"
elif [ $choice -eq 2 ]; then
    mapper_script="/home/hadoop/Assignment_01/Part_01/mapper2.py"
    reducer_script="/home/hadoop/Assignment_01/Part_01/reducer2.py"
else
    echo "Invalid choice."
    exit 1
fi

# Run the Hadoop streaming job
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-3.3.6.jar \
    -file $mapper_script \
    -mapper "/usr/bin/python3 $mapper_script" \
    -file $reducer_script \
    -reducer "/usr/bin/python3 $reducer_script" \
    -input $hdfs_input \
    -output $hdfs_output

echo "Job completed. Output stored in: $hdfs_output"
