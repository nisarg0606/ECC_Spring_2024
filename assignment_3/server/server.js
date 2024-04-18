const net = require("net");
const fs = require("fs");
const crypto = require("crypto");

const HOST = process.argv[2] || "localhost";
const PORT = process.argv[3] || 8080;

const motivationQuotes = [
  "The only way to do great work is to love what you do. - Steve Jobs",
  "Believe you can and you're halfway there. - Theodore Roosevelt",
  "Success is not final, failure is not fatal: It is the courage to continue that counts. - Winston Churchill",
  "The future belongs to those who believe in the beauty of their dreams. - Eleanor Roosevelt",
  "Your limitation—it's only your imagination.",
  "Push yourself, because no one else is going to do it for you.",
  "The only limit to our realization of tomorrow will be our doubts of today. - Franklin D. Roosevelt",
  "The harder you work for something, the greater you'll feel when you achieve it.",
  "Don't stop when you're tired. Stop when you're done.",
  "You are never too old to set another goal or to dream a new dream. - C.S. Lewis",
  "The only way to achieve the impossible is to believe it is possible.",
  "Success doesn't just find you. You have to go out and get it.",
  "It's not whether you get knocked down, it's whether you get up. - Vince Lombardi",
  "The journey of a thousand miles begins with one step. - Lao Tzu",
  "You are braver than you believe, stronger than you seem, and smarter than you think. - A.A. Milne",
  "Opportunities don't happen, you create them. - Chris Grosser",
  "Don't wait for opportunity. Create it.",
  "You are what you do, not what you say you'll do. - C.G. Jung",
  "The secret of getting ahead is getting started. - Mark Twain",
  "The only place where success comes before work is in the dictionary. - Vidal Sassoon",
  "Success is walking from failure to failure with no loss of enthusiasm. - Winston Churchill",
  "In the middle of difficulty lies opportunity. - Albert Einstein",
  "The only person you should try to be better than is the person you were yesterday.",
  "Your time is limited, don't waste it living someone else's life. - Steve Jobs",
  "Everything you can imagine is real. - Pablo Picasso",
  "Believe in yourself. You are braver than you think, more talented than you know, and capable of more than you imagine. - Roy T. Bennett",
  "Do one thing every day that scares you. - Eleanor Roosevelt",
  "What you get by achieving your goals is not as important as what you become by achieving your goals. - Zig Ziglar",
  "Life is 10% what happens to us and 90% how we react to it. - Charles R. Swindoll",
  "The only way to achieve the impossible is to believe it is possible. - Charles Kingsleigh (Alice in Wonderland)",
  "Act as if what you do makes a difference. It does. - William James",
  "The best time to plant a tree was 20 years ago. The second best time is now. - Chinese Proverb",
  "The only limit to our realization of tomorrow will be our doubts of today. - Franklin D. Roosevelt",
  "What lies behind us and what lies before us are tiny matters compared to what lies within us. - Ralph Waldo Emerson",
  "The biggest risk is not taking any risk. In a world that's changing really quickly, the only strategy that is guaranteed to fail is not taking risks. - Mark Zuckerberg",
  "Don't watch the clock; do what it does. Keep going. - Sam Levenson",
  "If you want to lift yourself up, lift up someone else. - Booker T. Washington",
  "The only person you are destined to become is the person you decide to be. - Ralph Waldo Emerson",
  "We may encounter many defeats but we must not be defeated. - Maya Angelou",
  "The only limit to our realization of tomorrow will be our doubts of today. - Franklin D. Roosevelt",
  "What you get by achieving your goals is not as important as what you become by achieving your goals. - Zig Ziglar",
  "The only way to do great work is to love what you do. - Steve Jobs",
  "Believe you can and you're halfway there. - Theodore Roosevelt",
  "Success is not final, failure is not fatal: It is the courage to continue that counts. - Winston Churchill",
  "The future belongs to those who believe in the beauty of their dreams. - Eleanor Roosevelt",
  "Your limitation—it's only your imagination.",
  "Push yourself, because no one else is going to do it for you.",
  "The only limit to our realization of tomorrow will be our doubts of today. - Franklin D. Roosevelt",
  "The harder you work for something, the greater you'll feel when you achieve it.",
  "Don't stop when you're tired. Stop when you're done.",
  "You are never too old to set another goal or to dream a new dream. - C.S. Lewis",
  "The only way to achieve the impossible is to believe it is possible.",
  "Success doesn't just find you. You have to go out and get it.",
  "It's not whether you get knocked down, it's whether you get up. - Vince Lombardi",
  "The journey of a thousand miles begins with one step. - Lao Tzu",
  "You are braver than you believe, stronger than you seem, and smarter than you think. - A.A. Milne",
  "Opportunities don't happen, you create them. - Chris Grosser",
  "Don't wait for opportunity. Create it.",
  "You are what you do, not what you say you'll do. - C.G. Jung",
  "The secret of getting ahead is getting started. - Mark Twain",
  "The only place where success comes before work is in the dictionary. - Vidal Sassoon",
  "Success is walking from failure to failure with no loss of enthusiasm. - Winston Churchill",
  "In the middle of difficulty lies opportunity. - Albert Einstein",
  "The only person you should try to be better than is the person you were yesterday.",
  "Your time is limited, don't waste it living someone else's life. - Steve Jobs",
];

const getRandomQuote = () => {
  const randomIndex = Math.floor(Math.random() * motivationQuotes.length);
  return motivationQuotes[randomIndex];
};

const server = net.createServer((socket) => {
  console.log(
    `Client connected from ${socket.remoteAddress}:${socket.remotePort}`
  );

  // Generate random data
  const randomData = Buffer.from(getRandomQuote());

  // Calculate checksum of random data
  const checksum = crypto.createHash("md5").update(randomData).digest("hex");

  // Write random data to file
  fs.writeFile("/app/serverdata/random_file.txt", randomData, (err) => {
    if (err) {
      console.error("Error writing file:", err);
      socket.end();
    } else {
      console.log("Random data written to random_file.txt");

      // Send file content to client
      fs.readFile("/app/serverdata/random_file.txt", (err, fileData) => {
        if (err) {
          console.error("Error reading file:", err);
          socket.end();
        } else {
          socket.write(fileData);
          console.log(
            `Sent file to client ${socket.remoteAddress}:${socket.remotePort} with checksum: ${checksum}`
          );
          socket.end(); // Close connection after sending data
        }
      });
    }
  });

  socket.on("end", () => {
    console.log(
      `Client ${socket.remoteAddress}:${socket.remotePort} disconnected`
    );
  });

  socket.on("error", (err) => {
    console.error("Socket error:", err);
  });
});

server.on("error", (err) => {
  console.error("Server error:", err);
});

server.listen(PORT, HOST, () => {
  console.log(`Server started on ${HOST}:${PORT}`);
});
