#!/bin/bash

# Ask the user for start and end times
read -p "Enter the start time (format HH): " start_hour
read -p "Enter the end time (format HH): " end_hour

# Define HDFS input and output paths
hdfs_input="/assignment01/input/access.log"
hdfs_output="/assignment01/java/part2/output/$(date +%s)"

# Check if the output directory exists, delete it if it does
hdfs dfs -test -d $hdfs_output
if [ $? -eq 0 ]; then
    echo "Deleting existing output directory: $hdfs_output"
    hdfs dfs -rm -r $hdfs_output
fi

# Compile Java code
javac /home/hadoop/assignment01/java/part2/Mapper.java
javac /home/hadoop/assignment01/java/part2/Reducer.java

# Create a JAR file
jar cf /home/hadoop/assignment01/java/part2/mymapreduce.jar /home/hadoop/assignment01/java/part2/*.class

# Upload the JAR file to HDFS
hdfs dfs -put /home/hadoop/assignment01/java/part2/mymapreduce.jar /assignment01/java/part2

# Run the Hadoop job
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-3.3.6.jar \
    -input $hdfs_input \
    -output $hdfs_output \
    -mapper "java -classpath /assignment01/java/part2/mymapreduce.jar Mapper" \
    -reducer "java -classpath /assignment01/java/part2/mymapreduce.jar Reducer" \
    -cmdenv TIMEFRAME="$start_hour-$end_hour"

echo "Job completed. Output stored in: $hdfs_output"
