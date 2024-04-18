# Assignment 3 ENGR-E 516: Engineering Cloud Computing

# Name: Nisarg Shah
Email: ns26@iu.edu
Enrollment number: 2001249104

# Links to download Docker Desktop and Image:

1. [Docker Desktop](https://www.docker.com/products/docker-desktop/) → Install Docker Desktop
2. [NodeJS image](https://hub.docker.com/_/node) → This is the NodeJS image which I used.

## To Follow along the assignment:

## Github Link:

[ECC_Spring_2024/assignment_3 at master · nisarg0606/ECC_Spring_2024](https://github.com/nisarg0606/ECC_Spring_2024/tree/master/assignment_3)

## Instructions to run the code:

### If you are using docker build and docker run then follow the below commands:

1. Git clone the repo
2. Install docker from the link above and then run the docker desktop
3. Navigate to server and client folder and run the commands which are shown in the screenshot below
4. Verify the result in docker desktop

### If you are using `docker-compose.yml`

1. Git clone the repo
2. Install docker desktop
3. Run `docker-compose up -d`
4. Verify the result in docker desktop

## Docker Desktop

### For this given assignment, I've installed Docker Desktop, which sets up and launches the Docker daemon on my computer. You can obtain Docker Desktop from the Docker website; the URL is given above.

![Untitled](Assignment%203%20ENGR-E%20516%20Engineering%20Cloud%20Computin%204cbff9ba83344e33b725860ad92a7630/Untitled.png)

## I am using Node.JS for this assignment for client and server so I will pull node image from DockerHub as per the command I had mentioned below

![Untitled](Assignment%203%20ENGR-E%20516%20Engineering%20Cloud%20Computin%204cbff9ba83344e33b725860ad92a7630/Untitled%201.png)

## I had created two volumes: 1. `servervol` and 2. `clientvol`

### → `servervol` is for server to store data

![Untitled](Assignment%203%20ENGR-E%20516%20Engineering%20Cloud%20Computin%204cbff9ba83344e33b725860ad92a7630/Untitled%202.png)

### → `clientvol` is for client to store data

![Untitled](Assignment%203%20ENGR-E%20516%20Engineering%20Cloud%20Computin%204cbff9ba83344e33b725860ad92a7630/Untitled%203.png)

## Creating a private network in the docker so both of containers can be connected there

![Untitled](Assignment%203%20ENGR-E%20516%20Engineering%20Cloud%20Computin%204cbff9ba83344e33b725860ad92a7630/Untitled%204.png)

## `server.js`

```jsx
const net = require("net");
const fs = require("fs");
const crypto = require("crypto");

const HOST = process.argv[2] || "localhost";
const PORT = process.argv[3] || 8080;
//array of quotes which contains 50 quotes
const motivationQuotes = [
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
  //if you want to run in local then remove the /app/serverdata
  fs.writeFile("/app/serverdata/random_file.txt", randomData, (err) => {
    if (err) {
      console.error("Error writing file:", err);
      socket.end();
    } else {
      console.log("Random data written to random_file.txt");

      // Send file content to client
      //if you want to run in local then remove the /app/serverdata
      fs.readFile("/app/serverdata/random_file.txt", (err, fileData) => {
        if (err) {
          console.error("Error reading file:", err);
          socket.end();
        } else {
          socket.write(fileData);
          console.log(
            `Sent file to client ${socket.remoteAddress}:${socket.remotePort} 
            with checksum: ${checksum}`
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

```

## `client.js`

```jsx
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
  //if you want to run in local then remove the /app/clientdata
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

```

## Before testing on Docker Let’s test on local system

![Untitled](Assignment%203%20ENGR-E%20516%20Engineering%20Cloud%20Computin%204cbff9ba83344e33b725860ad92a7630/Untitled%205.png)

## `random_quote.txt` which client has received

![Untitled](Assignment%203%20ENGR-E%20516%20Engineering%20Cloud%20Computin%204cbff9ba83344e33b725860ad92a7630/Untitled%206.png)

## Now, let’s run on docker. So, here is the Docker file of both

## `Dockerfile` for server.js

```docker
# Use the official Node.js 14.17.0 image
FROM node:14.17.0-alpine

# Set working directory inside the container
WORKDIR /app

# Copy server.js to the working directory
COPY server.js /app/server.js

# create a dir for serverdata
RUN mkdir /app/serverdata

EXPOSE 8080

# Command to run the server
CMD ["node", "server.js" , "0.0.0.0", "8080"]

```

## `Dockerfile` for client.js

```docker
# Use the official Node.js 14.17.0 image
FROM node:14.17.0-alpine

# Set working directory inside the container
WORKDIR /app

# Copy client.js to the working directory
COPY client.js /app/client.js

# Create a directory for the client
RUN mkdir /app/clientdata

# Command to run the client
CMD ["node", "client.js", "server", "8080"]

```

### Here we are using alpine version so the image is not that big and it contains basic functionality

## Let’s build docker Image

## server image build status

![Untitled](Assignment%203%20ENGR-E%20516%20Engineering%20Cloud%20Computin%204cbff9ba83344e33b725860ad92a7630/Untitled%207.png)

## client image build status

![Untitled](Assignment%203%20ENGR-E%20516%20Engineering%20Cloud%20Computin%204cbff9ba83344e33b725860ad92a7630/Untitled%208.png)

## Images of Client and Server

![Untitled](Assignment%203%20ENGR-E%20516%20Engineering%20Cloud%20Computin%204cbff9ba83344e33b725860ad92a7630/Untitled%209.png)

### We can see that the images are created and we can directly run using the run button but as mentioned in the assignment we mention the port and volume in the command line as shown below

## Create container and run on the docker

## server run command

![Untitled](Assignment%203%20ENGR-E%20516%20Engineering%20Cloud%20Computin%204cbff9ba83344e33b725860ad92a7630/Untitled%2010.png)

## client run command

![Untitled](Assignment%203%20ENGR-E%20516%20Engineering%20Cloud%20Computin%204cbff9ba83344e33b725860ad92a7630/Untitled%2011.png)

## Running Containers:

![Untitled](Assignment%203%20ENGR-E%20516%20Engineering%20Cloud%20Computin%204cbff9ba83344e33b725860ad92a7630/Untitled%2012.png)

## Logs of server

![Untitled](Assignment%203%20ENGR-E%20516%20Engineering%20Cloud%20Computin%204cbff9ba83344e33b725860ad92a7630/Untitled%2013.png)

From the logs we can see that the file was generated and sent to client

## Logs of client

![Untitled](Assignment%203%20ENGR-E%20516%20Engineering%20Cloud%20Computin%204cbff9ba83344e33b725860ad92a7630/Untitled%2014.png)

Here we can see that the random quote was received and stored in the volume

## Let’s see the output in File/Volume

## `servervol`

![Untitled](Assignment%203%20ENGR-E%20516%20Engineering%20Cloud%20Computin%204cbff9ba83344e33b725860ad92a7630/Untitled%2015.png)

Here we can see that the output was stored in the servervol and the random_file.txt’s output is also visible

## `clientvol`

![Untitled](Assignment%203%20ENGR-E%20516%20Engineering%20Cloud%20Computin%204cbff9ba83344e33b725860ad92a7630/Untitled%2016.png)

Similarly, we can see that the same random quote is stored in clientvol

### To make the assignment fun I had used random Quotes instead of random data of 1kb. If one wants to generate 1kb data only one then one can use the below function in the `server.js` and call it at random data

 

```jsx
const FILE_SIZE = 1024; // 1KB

// Function to generate random data of specified length
const generateRandomData = (length) => {
  return crypto.randomBytes(length);
};

const randomData = generateRandomData(FILE_SIZE);
```

## To confirm that our both containers are running on same network , we can use this command

 

![Untitled](Assignment%203%20ENGR-E%20516%20Engineering%20Cloud%20Computin%204cbff9ba83344e33b725860ad92a7630/Untitled%2017.png)

From the screenshot above we can see that both the containers are running on the same network nisarg

# Automation/Addition Exercise

## `docker-compose.yml`

```docker
version: "3"

services:
  server:
    build:
      context: ./server
      dockerfile: Dockerfile
    networks:
      - nisarg
    volumes:
      - servervol:/app/serverdata

  client:
    build:
      context: ./client
      dockerfile: Dockerfile
    volumes:
      - clientvol:/app/clientdata
    networks:
      - nisarg

volumes:
  servervol:
  clientvol:

networks:
  nisarg:

```

## Running docker-compose.yml

![Untitled](Assignment%203%20ENGR-E%20516%20Engineering%20Cloud%20Computin%204cbff9ba83344e33b725860ad92a7630/Untitled%2018.png)

## Client and Server Image Created

![Untitled](Assignment%203%20ENGR-E%20516%20Engineering%20Cloud%20Computin%204cbff9ba83344e33b725860ad92a7630/Untitled%2019.png)

## Client and Server Volume Created

![Untitled](Assignment%203%20ENGR-E%20516%20Engineering%20Cloud%20Computin%204cbff9ba83344e33b725860ad92a7630/Untitled%2020.png)

## Containers Created under assignment

![Untitled](Assignment%203%20ENGR-E%20516%20Engineering%20Cloud%20Computin%204cbff9ba83344e33b725860ad92a7630/Untitled%2021.png)

## Logs of server

![Untitled](Assignment%203%20ENGR-E%20516%20Engineering%20Cloud%20Computin%204cbff9ba83344e33b725860ad92a7630/Untitled%2022.png)

## Logs of Client

![Untitled](Assignment%203%20ENGR-E%20516%20Engineering%20Cloud%20Computin%204cbff9ba83344e33b725860ad92a7630/Untitled%2023.png)

## Output which was sent to client stored in servervol

![Untitled](Assignment%203%20ENGR-E%20516%20Engineering%20Cloud%20Computin%204cbff9ba83344e33b725860ad92a7630/Untitled%2024.png)

## Output from server stored in clientvol

![Untitled](Assignment%203%20ENGR-E%20516%20Engineering%20Cloud%20Computin%204cbff9ba83344e33b725860ad92a7630/Untitled%2025.png)

---

---

# ________________________The End _______________________