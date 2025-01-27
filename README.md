SoleCheck Documentation.

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
