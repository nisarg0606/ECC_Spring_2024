 #!/bin/bash

# Redirect all output to a log file
exec > >(tee -i cmd_wordcount_$(date '+%Y-%m-%d').log)
exec 2>&1

# Define HDFS input and output paths
hdfs_input="/Input/example.txt"
hdfs_output="/assignment1/WordCount_Output/wc_output_$(date '+%Y-%m-%d')"

# Check if the output directory exists, delete it if it does
hdfs dfs -test -d $hdfs_output
if [ $? -eq 0 ]; then
    echo "Deleting existing output directory: $hdfs_output"
    hdfs dfs -rm -r $hdfs_output
fi

# Run the Hadoop streaming job
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-3.3.6.jar \
    -mapper "/usr/bin/python3 /home/hadoop/ECC_Spring_2024/assignment1/Examples/WordCount/mapper.py" \
    -reducer "/usr/bin/python3 /home/hadoop/ECC_Spring_2024/assignment1/WordCount/reducer.py" \
    -input $hdfs_input \
    -output $hdfs_output

echo "Job completed. Output stored in: $hdfs_output"

# Store the HDFS output to local file system in a text file
hdfs dfs -cat $hdfs_output/part-00000 > /home/hadoop/output_wordcount_$(date '+%Y-%m-%d').txt

echo "Output stored in local file system: /home/hadoop/output_wordcount_$(date '+%Y-%m-%d').txt"