#!/bin/bash

# Ask the user for start and end times
read -p "Enter the start time (format HH): " start_hour
read -p "Enter the end time (format HH): " end_hour

# Define HDFS input and output paths
hdfs_input="/Assignment_01/Input/access.log"
hdfs_output="/Assignment_01/Part_02/output/$(date +'%d-%B-%Y-%H-%M-%S')"

# Check if the output directory exists, delete it if it does
hdfs dfs -test -d $hdfs_output
if [ $? -eq 0 ]; then
    echo "Deleting existing output directory: $hdfs_output"
    hdfs dfs -rm -r $hdfs_output
fi

mapper_script="/home/hadoop/Assignment_01/Part_02/mapper2.py"
reducer_script="/home/hadoop/Assignment_01/Part_02/reducer2.py"
# Run the Hadoop streaming job
#-file /home/hadoop/Assignment_01/Part_02/mapper2.py \
#-file /home/hadoop/Assignment_01/Part_02/reducer2.py \
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-3.3.6.jar \
    -file $mapper_script \
    -mapper "/usr/bin/python3 /home/hadoop/Assignment_01/Part_02/mapper2.py" \
    -file $reducer_script \
    -reducer "/usr/bin/python3 /home/hadoop/Assignment_01/Part_02/reducer2.py" \
    -input $hdfs_input \
    -cmdenv TIMEFRAME="$start_hour-$end_hour" \
    -output $hdfs_output

echo "Job completed. Output stored in: $hdfs_output"
