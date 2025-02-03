SoleCheck Documentation.

WEBSITES:
https://escapeadmire.github.io/SoleCheck/
solecheck.info

To compare the data from an NFC tag with data stored in an SQL database, you can follow these steps:

---

### **1. Overview of the Process**
1. **Retrieve NFC Data:** Use the `NDEFReader` API to read the data from the NFC tag.
2. **Send NFC Data to the Backend:** Use a `POST` request (e.g., using `fetch` or `axios`) to send the tag's data to a backend server.
3. **Query SQL Database:** Use a backend programming language (e.g., Python, Node.js, PHP) to query the SQL database for a match.
4. **Return the Result:** Send the query result back to the frontend to handle user feedback or actions.

---

### **2. Example Setup**

#### **Frontend (JavaScript)**
This part reads NFC data and sends it to the backend.

```javascript
const readNfcButton = document.getElementById('readNfc');
const outputDiv = document.getElementById('output');

if ('NDEFReader' in window) {
    readNfcButton.addEventListener('click', async () => {
        try {
            const ndef = new NDEFReader();
            outputDiv.textContent = 'Starting Shoe scan...';

            await ndef.scan();
            outputDiv.textContent = 'Please tap a shoe with SoleCheck.';

            ndef.onreading = async (event) => {
                const message = event.message.records.map((record) => {
                    if (record.recordType === 'text') {
                        const textDecoder = new TextDecoder(record.encoding);
                        return textDecoder.decode(record.data);
                    }
                }).join('\n');

                outputDiv.textContent = `Tag read: ${message}`;

                // Send NFC data to the server for validation
                const response = await fetch('https://yourserver.com/verify', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({ nfcData: message }),
                });

                const result = await response.json();

                if (result.valid) {
                    outputDiv.textContent = `Valid shoe detected: ${result.shoeName}`;
                } else {
                    outputDiv.textContent = 'Invalid shoe or data not found.';
                }
            };
        } catch (error) {
            outputDiv.textContent = `Error: ${error.message}`;
        }
    });
} else {
    outputDiv.textContent = 'NFC is not supported on this device.';
}
```

---

#### **Backend (Node.js Example with Express and MySQL)**

This backend receives the NFC data, queries the SQL database, and returns the result.

1. **Install Dependencies**
   ```bash
   npm install express mysql body-parser
   ```

2. **Backend Code**
   ```javascript
   const express = require('express');
   const mysql = require('mysql');
   const bodyParser = require('body-parser');

   const app = express();
   app.use(bodyParser.json());

   // MySQL Database Connection
   const db = mysql.createConnection({
       host: 'localhost',
       user: 'root',
       password: 'yourpassword',
       database: 'solecheck_db',
   });

   db.connect((err) => {
       if (err) {
           console.error('Database connection failed:', err);
       } else {
           console.log('Connected to database.');
       }
   });

   // Endpoint to Verify NFC Data
   app.post('/verify', (req, res) => {
       const { nfcData } = req.body;

       if (!nfcData) {
           return res.status(400).json({ error: 'No NFC data provided.' });
       }

       const query = 'SELECT * FROM shoes WHERE nfc_tag = ?';
       db.query(query, [nfcData], (err, results) => {
           if (err) {
               console.error('Database query error:', err);
               return res.status(500).json({ error: 'Internal Server Error' });
           }

           if (results.length > 0) {
               res.json({ valid: true, shoeName: results[0].name });
           } else {
               res.json({ valid: false });
           }
       });
   });

   // Start the server
   const PORT = 3000;
   app.listen(PORT, () => {
       console.log(`Server running on http://localhost:${PORT}`);
   });
   ```

---

### **3. SQL Database Table Example**
Here's a possible structure for your SQL database table (`shoes`):

| **id** | **name**          | **nfc_tag**    |
|--------|-------------------|----------------|
| 1      | Yeezy Boost 350   | BOOST350123    |
| 2      | Air Jordan 1      | AIRJORDAN123   |
| 3      | Nike Air Max 90   | AIRMAX90123    |

---

### **4. Testing the Setup**
1. Add NFC tag data (e.g., `BOOST350123`) into the `nfc_tag` column in your database.
2. Tap an NFC tag.
3. The frontend sends the NFC data to the backend.
4. The backend queries the database and responds with the result.
5. The frontend displays whether the shoe is valid or not.

---

### **5. Considerations**
- **Data Validation:** Sanitize the NFC data before using it in SQL queries to prevent SQL injection (e.g., using parameterized queries like in the Node.js example).
- **HTTPS:** Always use HTTPS to encrypt NFC data transmission.
- **Scalability:** For larger datasets, consider adding indexing on the `nfc_tag` column for faster searches.

Would you like a specific backend language or database example elaborated further?

Creating an SQL database depends on the database management system (DBMS) you choose (e.g., MySQL, PostgreSQL, SQLite). Below, I'll guide you through the steps to create an SQL database in MySQL, which is one of the most popular and widely used DBMS options.

1. Install MySQL
If MySQL is not installed yet:

On Ubuntu:
bash
Copy
Edit
sudo apt update
sudo apt install mysql-server
On Windows/Mac: Download the installer from the official MySQL website.
2. Access the MySQL Command Line
After installing MySQL:

Start the MySQL service:

On Ubuntu:
bash
Copy
Edit
sudo service mysql start
On Windows, start it through the MySQL Workbench or the MySQL Command-Line Client.
Log in to MySQL:

bash
Copy
Edit
mysql -u root -p
Enter your password when prompted.

3. Create a Database
Use the following command to create a database:

sql
Copy
Edit
CREATE DATABASE solecheck_db;
Verify that the database was created:

sql
Copy
Edit
SHOW DATABASES;
You should see solecheck_db listed.

4. Use the Database
Switch to the new database:

sql
Copy
Edit
USE solecheck_db;
5. Create a Table
To store data, create a table. For example, to store NFC shoe tag data:

sql
Copy
Edit
CREATE TABLE shoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    nfc_tag VARCHAR(255) UNIQUE NOT NULL
);
Breakdown of the shoes Table:
id: A unique identifier for each row (auto-increments).
name: The name of the shoe (e.g., "Yeezy Boost 350").
nfc_tag: The NFC tag associated with the shoe (must be unique).
6. Insert Data into the Table
Insert data into the shoes table:

sql
Copy
Edit
INSERT INTO shoes (name, nfc_tag) VALUES 
('Yeezy Boost 350', 'BOOST350123'),
('Air Jordan 1', 'AIRJORDAN123'),
('Nike Air Max 90', 'AIRMAX90123');
7. View the Data
Check the data you've inserted:

sql
Copy
Edit
SELECT * FROM shoes;
You should see:

diff
Copy
Edit
+----+------------------+--------------+
| id | name             | nfc_tag      |
+----+------------------+--------------+
|  1 | Yeezy Boost 350  | BOOST350123  |
|  2 | Air Jordan 1     | AIRJORDAN123 |
|  3 | Nike Air Max 90  | AIRMAX90123  |
+----+------------------+--------------+
8. Manage the Database
Update Records:

sql
Copy
Edit
UPDATE shoes SET name = 'Adidas Yeezy Boost 350' WHERE nfc_tag = 'BOOST350123';
Delete Records:

sql
Copy
Edit
DELETE FROM shoes WHERE nfc_tag = 'AIRJORDAN123';
9. GUI Alternative (Optional)
If you prefer a graphical interface:

Use MySQL Workbench to manage your database visually.
You can create a database, tables, and perform queries without using the command line.
10. Connect the Database to Your Backend
You can now use your database in a backend language like:

Node.js: Use the mysql package.
Python: Use the mysql-connector-python library.
PHP: Use PDO or MySQLi.
Would you like to see an example of connecting to your database using one of these languages?








You said:
how many servers do I need for this project?
ChatGPT said:
ChatGPT
The number of servers you need for your project depends on factors like the scale of your application, expected user load, and whether you want to separate concerns (e.g., front-end, back-end, database). Below is an analysis tailored to your project:

1. For a Small-Scale Project (Prototype/Testing)
1 Server (or a single machine):
Host everything on one server:
Frontend (HTML/JavaScript files).
Backend (Node.js, Python, PHP, etc.).
Database (MySQL).
Suitable if:
The user base is small (e.g., <100 users/day).
Minimal traffic is expected.
You’re in the development/testing phase.
Example Setup:
Use Ubuntu 24.04 or similar.
Install:
Nginx/Apache: Web server for the frontend and backend.
MySQL: For the database.
Backend language runtime (Node.js, Python, etc.).
2. For a Medium-Scale Project
2 Servers:
Application Server:
Hosts the frontend and backend application (e.g., HTML/JS, Node.js).
Database Server:
Hosts the SQL database (e.g., MySQL or PostgreSQL).
Separating the database ensures better performance and security (e.g., prevent direct access to the DB from outside).
Suitable if:
Expecting moderate traffic (e.g., 1,000-5,000 users/day).
You want better scalability and reliability.
3. For a Large-Scale Project
3 or More Servers:
Frontend Server:
Serves the frontend (static files like HTML, CSS, JS).
Use a CDN (e.g., Cloudflare) for caching and faster delivery.
Backend/API Server:
Handles the NFC verification logic and communicates with the database.
Database Server:
Dedicated to storing and retrieving data securely.
Optional Additions:
Load Balancer:
Distributes traffic between multiple backend servers.
Use tools like NGINX or AWS Elastic Load Balancer.
Caching Server:
Use Redis or Memcached for faster data retrieval.
Backup Server:
Regularly back up your database and application files.
Suitable if:
You expect heavy traffic (e.g., 10,000+ users/day).
High availability and reliability are critical.
You want redundancy and failover capabilities.
4. Cloud Hosting Option
Instead of physical servers, you can use cloud services like AWS, Azure, or Google Cloud to scale resources dynamically based on demand. Here's a typical cloud architecture:

Frontend: Use a static website hosting service (e.g., AWS S3, Netlify).
Backend: Deploy on a platform like AWS EC2, Azure App Service, or Google Cloud Run.
Database: Use managed databases (e.g., AWS RDS, Azure Database for MySQL).
Recommended Setup for Your Project
Given your project involves NFC verification and database queries:

For Development/Testing:
Start with 1 server (or even your local machine) hosting the frontend, backend, and database.
For Production (Medium Scale):
2 servers:
One for the application (frontend + backend).
One for the database.
Would you like guidance on configuring the servers, setting up a load balancer, or deploying on the cloud?
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
To compare NFC data received on an HTML page with a database, you'll need to follow these steps:

---

### *1. Set Up Your HTML Page*
Your HTML page should include:
- A form or input field to capture NFC data.
- JavaScript to handle the NFC data and send it to the backend.

Example HTML:
html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>NFC Data Check</title>
</head>
<body>
  <h1>NFC Data Check</h1>
  <input type="text" id="nfcData" placeholder="Scan NFC Tag">
  <button onclick="checkNFCData()">Check Data</button>
  <p id="result"></p>

  <script>
    async function checkNFCData() {
      const nfcData = document.getElementById('nfcData').value;

      if (!nfcData) {
        alert('Please scan an NFC tag.');
        return;
      }

      try {
        const response = await fetch('/check-nfc', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({ nfcData }),
        });

        const result = await response.json();
        document.getElementById('result').innerText = result.message;
      } catch (error) {
        console.error('Error:', error);
        document.getElementById('result').innerText = 'An error occurred.';
      }
    }
  </script>
</body>
</html>


---

### *2. Set Up the Backend*
Your backend will:
- Receive the NFC data from the frontend.
- Query the database to check if the NFC data exists.
- Send a response back to the frontend.

#### Example in Node.js with Express and MySQL:
1. Install dependencies:
   bash
   npm install express mysql2 cors
   

2. Create the backend server:
   javascript
   const express = require('express');
   const mysql = require('mysql2');
   const cors = require('cors');

   const app = express();
   app.use(cors());
   app.use(express.json());

   // Database connection
   const db = mysql.createConnection({
     host: 'localhost',
     user: 'root',
     password: '',
     database: 'nfc_database'
   });

   db.connect((err) => {
     if (err) throw err;
     console.log('Connected to the database');
   });

   // Endpoint to check NFC data
   app.post('/check-nfc', (req, res) => {
     const { nfcData } = req.body;

     if (!nfcData) {
       return res.status(400).json({ message: 'NFC data is required' });
     }

     const query = 'SELECT * FROM nfc_tags WHERE tag_id = ?';
     db.query(query, [nfcData], (err, results) => {
       if (err) {
         console.error('Database error:', err);
         return res.status(500).json({ message: 'Database error' });
       }

       if (results.length > 0) {
         res.json({ message: 'NFC data found in the database' });
       } else {
         res.json({ message: 'NFC data not found' });
       }
     });
   });

   const PORT = 3000;
   app.listen(PORT, () => {
     console.log(`Server is running on port ${PORT}`);
   });
   

---

### *3. Set Up the Database*
Create a table to store NFC tag data. For example:
sql
CREATE TABLE nfc_tags (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tag_id VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


Insert some sample data:
sql
INSERT INTO nfc_tags (tag_id) VALUES ('1234567890'), ('0987654321');


---

### *4. Test the Application*
1. Run your backend server:
   bash
   node server.js
   
2. Open your HTML page in a browser.
3. Enter NFC data in the input field and click "Check Data."
4. The result will be displayed on the page.

---

### *5. Optional: Add NFC Scanning*
If you want to scan NFC tags directly in the browser:
- Use the [Web NFC API](https://developer.mozilla.org/en-US/docs/Web/API/Web_NFC_API) (currently supported in Chrome for Android).
- Modify your JavaScript to read NFC data automatically.

Example:
javascript
if ('NDEFReader' in window) {
  const nfcReader = new NDEFReader();

  nfcReader.scan()
    .then(() => {
      nfcReader.onreading = (event) => {
        const nfcData = event.serialNumber; // Extract NFC data
        document.getElementById('nfcData').value = nfcData;
        checkNFCData(); // Automatically check the data
      };
    })
    .catch(error => console.error('Error scanning NFC:', error));
} else {
  console.log('Web NFC is not supported in this browser.');
}


---

### *6. Deploy Your Application*
- Deploy your backend to a hosting provider (e.g., Heroku, AWS).
- Host your HTML page on a static site host (e.g., Netlify, Vercel) or serve it with your backend.

---

Let me know if you need further assistance!
