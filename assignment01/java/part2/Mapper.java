package assignment01.java.part2;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.Date;

public class Mapper {

    public static void main(String[] args) throws IOException, ParseException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        String line;

        // Regular expression pattern to match IP addresses and timestamps
        Pattern logPattern = Pattern.compile("(\\d+\\.\\d+\\.\\d+\\.\\d+) .* \\[(.*?)\\]");

        while ((line = br.readLine()) != null) {
            Matcher matcher = logPattern.matcher(line.trim());
            if (matcher.find()) {
                String ip = matcher.group(1);
                String timestampStr = matcher.group(2).split(" ")[0]; // Extracting date from timestamp

                SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MMM/yyyy:HH:mm:ss");
                Date timestamp = dateFormat.parse(timestampStr);
                SimpleDateFormat hourFormat = new SimpleDateFormat("yyyy-MM-dd HH");
                String hour = hourFormat.format(timestamp);

                System.out.println(hour + "\t" + ip + "\t1"); // Emitting hour, IP, and count
            }
        }
    }
}
