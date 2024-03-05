#!/bin/bash

# Define HDFS input and output paths
hdfs_input="/assignment01/input/access.log"
# Keep the output directory dynamic
hdfs_output="/assignment01/java/part1/output/$(date +%s)"

# Check if the output directory exists, delete it if it does
hdfs dfs -test -d $hdfs_output
if [ $? -eq 0 ]; then
    echo "Deleting existing output directory: $hdfs_output"
    hdfs dfs -rm -r $hdfs_output
fi

# Compile Java code
javac /home/hadoop/assignment01/java/part1/Mapper.java
javac /home/hadoop/assignment01/java/part1/Reducer.java

# Create a JAR file
jar cf /home/hadoop/assignment01/java/part1/mymapreduce.jar /home/hadoop/assignment01/java/part1/*.class

# Upload the JAR file to HDFS
hdfs dfs -put /home/hadoop/assignment01/java/part1/mymapreduce.jar /assignment01/java/part1

# Run the Hadoop job
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-3.3.6.jar \
    -input $hdfs_input \
    -output $hdfs_output \
    -mapper "java -classpath /assignment01/java/part1/mymapreduce.jar Mapper" \
    -reducer "java -classpath /assignment01/java/part1/mymapreduce.jar Reducer"

echo "Job completed. Output stored in: $hdfs_output"
