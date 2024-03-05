package assignment01.java.part1;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

public class Reducer {

    public static void main(String[] args) throws IOException, ParseException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        String line;

        Map<String, Map<String, Integer>> hourlyIpCount = new HashMap<>();

        while ((line = br.readLine()) != null) {
            line = line.trim();
            String[] parts = line.split("\t", 3);
            String hour = parts[0];
            String ip = parts[1];
            int count = Integer.parseInt(parts[2]);

            if (!hourlyIpCount.containsKey(hour)) {
                hourlyIpCount.put(hour, new HashMap<>());
            }
            Map<String, Integer> ipCounts = hourlyIpCount.get(hour);
            ipCounts.put(ip, ipCounts.getOrDefault(ip, 0) + count);
        }

        // Iterate through each hour
        for (Map.Entry<String, Map<String, Integer>> entry : hourlyIpCount.entrySet()) {
            String hour = entry.getKey();
            SimpleDateFormat hourFormat = new SimpleDateFormat("HH");
            Date startTime = hourFormat.parse(hour);
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(startTime);
            calendar.add(Calendar.HOUR, 1);
            calendar.add(Calendar.SECOND, -1);
            Date endTime = calendar.getTime();

            SimpleDateFormat hourRangeFormat = new SimpleDateFormat("HH:mm:ss");
            String hourRange = hourRangeFormat.format(startTime) + " to " + hourRangeFormat.format(endTime);

            // Sort IP addresses based on their counts
            List<Map.Entry<String, Integer>> sortedIps = new ArrayList<>(entry.getValue().entrySet());
            sortedIps.sort(Map.Entry.comparingByValue(Comparator.reverseOrder()));

            // Output the top 3 IP addresses for each hour
            System.out.println("Top 3 IP addresses from " + hourRange + ":");
            for (int i = 0; i < Math.min(3, sortedIps.size()); i++) {
                Map.Entry<String, Integer> ipEntry = sortedIps.get(i);
                System.out.println("IP: " + ipEntry.getKey() + ", Count: " + ipEntry.getValue());
            }
        }
    }
}
