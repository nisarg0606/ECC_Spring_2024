import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.*;

public class Reducer {

    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        Map<String, Integer> hourlyIpCount = new HashMap<>();

        // Accept user input for hour range
        String[] hours = args[0].split("-");
        int startHour = Integer.parseInt(hours[0]);
        int endHour = Integer.parseInt(hours[1]);

        String line;
        while ((line = br.readLine()) != null) {
            String[] parts = line.trim().split("\t", 3);
            if (parts.length != 3) {
                continue;
            }
            String hour = parts[0];
            int hourInt = Integer.parseInt(hour.substring(hour.length() - 2));

            // Check if the hour falls within the user-defined range
            if (hourInt >= startHour && hourInt < endHour) {
                String ip = parts[1];
                int count = Integer.parseInt(parts[2]);
                hourlyIpCount.put(ip, hourlyIpCount.getOrDefault(ip, 0) + count);
            }
        }

        // Sort IP addresses based on their counts
        List<Map.Entry<String, Integer>> sortedIps = new ArrayList<>(hourlyIpCount.entrySet());
        sortedIps.sort(Map.Entry.comparingByValue(Comparator.reverseOrder()));

        // Output the top 3 IP addresses for the specified hour range
        System.out.printf("Top 3 IP addresses from %02d:00:00 to %02d:59:59:%n", startHour, endHour - 1);
        int count = 0;
        for (Map.Entry<String, Integer> entry : sortedIps) {
            if (count >= 3) {
                break;
            }
            System.out.printf("    IP: %s, Count: %d%n", entry.getKey(), entry.getValue());
            count++;
        }
    }
}
