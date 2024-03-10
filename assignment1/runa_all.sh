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
hdfs_output_part2="/assignment1/Output/Part_02_Output_${start_time}_${end_time}"
wordcount_output="/assignment1/Output/WordCount_Output/wc_output_$(date '+%Y-%m-%d-%H-%M')"
grep_output="/assignment1/Output/Grep_Output/grep_output_$(date '+%Y-%m-%d-%H-%M')"
sort_output="/assignment1/Output/Sort_Output/sort_output_$(date '+%Y-%m-%d-%H-%M')"

hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-3.3.6.jar \
    -D mapreduce.job.name="Part 02 - Access Log" \
    -D mapreduce.job.reuse.jvm.num.tasks=4 \
    -D mapreduce.job.maps=4 \
    -D mapreduce.job.reduces=1 \
    -mapper "/usr/bin/python3 /home/hadoop/ECC_Spring_2024/assignment1/Part_02/mapper.py" \
    -reducer "/usr/bin/python3 /home/hadoop/ECC_Spring_2024/assignment1/Part_02/reducer.py $start_time-$end_time" \
    -input $hdfs_input \
    -output $hdfs_output_part2 &

hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-3.3.6.jar \
    -D mapreduce.job.name="WordCount Example" \
    -D mapreduce.job.reuse.jvm.num.tasks=4 \
    -D mapreduce.job.maps=4 \
    -D mapreduce.job.reduces=1 \
    -mapper "/usr/bin/python3 /home/hadoop/ECC_Spring_2024/assignment1/Examples/WordCount/mapper.py" \
    -reducer "/usr/bin/python3 /home/hadoop/ECC_Spring_2024/assignment1/WordCount/reducer.py" \
    -input $hdfs_input \
    -output $wordcount_output &

hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-3.3.6.jar \
    -D mapreduce.job.name="Grep Example" \
    -D mapreduce.job.reuse.jvm.num.tasks=4 \
    -D mapreduce.job.maps=4 \
    -D mapreduce.job.reduces=1 \
    -mapper "/usr/bin/python3 /home/hadoop/ECC_Spring_2024/assignment1/Examples/Grep/mapper.py $pattern" \
    -reducer "/usr/bin/python3 /home/hadoop/ECC_Spring_2024/assignment1/Examples/Grep/reducer.py" \
    -input $hdfs_input \
    -output $grep_output &

hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-3.3.6.jar \
    -D mapreduce.job.name="Sort Example" \
    -D mapreduce.job.reuse.jvm.num.tasks=4 \
    -D mapreduce.job.maps=4 \
    -D mapreduce.job.reduces=1 \
    -mapper "/usr/bin/python3 /home/hadoop/ECC_Spring_2024/assignment1/Examples/Sort/mapper.py" \
    -reducer "/usr/bin/python3 /home/hadoop/ECC_Spring_2024/assignment1/Examples/Sort/reducer.py" \
    -input $hdfs_input \
    -output $sort_output &
wait

echo "Job completed. Output stored in: $hdfs_output_part2, $wordcount_output, $grep_output, $sort_output"