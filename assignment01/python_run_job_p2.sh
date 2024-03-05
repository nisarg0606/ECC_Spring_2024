#!/bin/bash

# Ask the user for start and end times
read -p "Enter the start time (format HH): " start_hour
read -p "Enter the end time (format HH): " end_hour

# Define HDFS input and output paths
hdfs_input="/assignment01/input/access.log"
hdfs_output="/assignment01/python/part2/output/$(date +%s)"

# Check if the output directory exists, delete it if it does
hdfs dfs -test -d $hdfs_output
if [ $? -eq 0 ]; then
    echo "Deleting existing output directory: $hdfs_output"
    hdfs dfs -rm -r $hdfs_output
fi

# Run the Hadoop streaming job
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-3.3.6.jar \
    -file /home/hadoop/assignment01/python/part2/mapper.py \
    -mapper "/usr/bin/python3 /home/hadoop/assignment01/python/part2/mapper.py" \
    -file /home/hadoop/assignment01/python/part2/reducer.py \
    -reducer "/usr/bin/python3 /home/hadoop/assignment01/python/part2/reducer.py" \
    -input $hdfs_input \
    -cmdenv TIMEFRAME="$start_hour-$end_hour" \
    -output $hdfs_output

echo "Job completed. Output stored in: $hdfs_output"
