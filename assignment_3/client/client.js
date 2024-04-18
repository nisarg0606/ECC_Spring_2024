const net = require("net");
const fs = require("fs");
const crypto = require("crypto");

const HOST = process.argv[2] || "localhost";
const PORT = process.argv[3] || 8080;

const clientSocket = new net.Socket();

clientSocket.connect(PORT, HOST, () => {
  console.log(`Connected to server on port ${PORT}`);

  // Send data to server
  clientSocket.write("Hey server, can you send me that random generated file?");
});

clientSocket.on("data", (data) => {
  console.log("Received file data:", data.toString());

  // Calculate checksum of received data
  const checksum = crypto.createHash("md5").update(data).digest("hex");

  console.log(`Data: ${data}`);
  // Write received data to file
  fs.writeFileSync("/app/clientdata/random_quote.txt", data);
  console.log(`Received file with checksum: ${checksum}`);

  clientSocket.write("Thanks for the file, server!");

  // Delay closing the connection for 2 minutes (120,000 milliseconds)
  setTimeout(() => {
    console.log("Closing connection after 2 minutes");
    clientSocket.end();
  }, 120000);
});

clientSocket.on("end", () => {
  console.log("Disconnected from server");
});

clientSocket.on("error", (err) => {
  console.error("Connection error:", err);
});
