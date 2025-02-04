# SoleCheck Documentation.

# WEBSITES:
https://escapeadmire.github.io/SoleCheck/
https://solecheck.info


# Shoe Tracking Using UUID and SQL Server Verification

## 1. Step-by-Step Process

### 1.1 NFC Tag Writing Process (Storing UUID)
- Generate a **UUID** (Universally Unique Identifier) for each shoe. This UUID will serve as a unique reference in your database.
- **Encrypt the UUID (Optional)**: For extra security, you can encrypt the UUID before storing it on the NFC tag, but for simplicity, storing the raw UUID is often enough.
- Write the **UUID** to the NFC tag (or associated NFC record).

### 1.2 Database Setup
On your **SQL Server**, create a table that will store the shoe data, including the UUID.

```sql
CREATE TABLE Shoes (
    id INT PRIMARY KEY IDENTITY(1,1),
    shoe_uuid UNIQUEIDENTIFIER NOT NULL,
    serial_number NVARCHAR(50),
    model NVARCHAR(100),
    manufacture_date DATETIME,
    other_details NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE()
);
```

### 1.3 Inserting a Shoe Record
When adding a shoe to the database, generate a UUID for it, and insert the details along with the UUID.

```sql
INSERT INTO Shoes (shoe_uuid, serial_number, model, manufacture_date, other_details)
VALUES (NEWID(), '12345-XYZ', 'Yeezy Boost 350', '2025-01-01', 'Additional shoe details');
```

### 1.4 Verifying the UUID (On NFC Scan)
When the NFC tag is scanned, read the **UUID**.
- Send this UUID to your backend API to query the **SQL Server** and verify if the UUID exists in the database.

### 1.5 Backend API (Verification Process)
Your backend system will receive the **UUID** from the NFC tag scan, and use it to query the database.

#### Backend Example using **Node.js** and **SQL Server**:

```javascript
const express = require('express');
const sql = require('mssql');
const app = express();

// Set up SQL Server connection
const config = {
    user: 'your_db_user',
    password: 'your_db_password',
    server: 'your_server',
    database: 'your_database',
    options: {
        encrypt: true, // for Azure
        trustServerCertificate: true // change to false if using a valid certificate
    }
};

// API to verify shoe UUID
app.get('/verify-shoe', async (req, res) => {
    const shoeUuid = req.query.uuid;

    try {
        // Connect to the SQL Server
        await sql.connect(config);

        // Query to find shoe with the given UUID
        const result = await sql.query`SELECT * FROM Shoes WHERE shoe_uuid = ${shoeUuid}`;

        if (result.recordset.length > 0) {
            // Shoe found, return shoe details
            res.json({
                status: 'success',
                message: 'Shoe found!',
                data: result.recordset[0]
            });
        } else {
            // Shoe not found
            res.json({
                status: 'error',
                message: 'Shoe not found in the database.'
            });
        }
    } catch (err) {
        console.error('SQL error', err);
        res.status(500).json({
            status: 'error',
            message: 'Internal Server Error'
        });
    }
});

app.listen(3000, () => {
    console.log('Server running on port 3000');
});
```

## 2. Flow Diagram

1. **Write UUID to NFC Tag**:
   - Generate a unique UUID.
   - Optionally encrypt the UUID (for additional security).
   - Write the UUID to the NFC tag.

2. **Scan NFC Tag**:
   - User taps the shoe with the NFC tag to scan.
   - Read the UUID from the NFC tag.

3. **Verify UUID in Backend**:
   - Send the UUID to your backend API.
   - The backend API queries the SQL Server to check if the UUID exists in the `Shoes` table.
   - If found, return the shoe details to the user.
   - If not found, notify the user that the shoe is not in the database.

## 3. Frontend Integration
Your frontend will send a request with the UUID to the backend. Here’s an example using **JavaScript (fetch)** to call the verification endpoint.

```javascript
// Function to verify shoe by UUID after NFC scan
async function verifyShoe(uuid) {
    try {
        const response = await fetch(`/verify-shoe?uuid=${uuid}`);
        const data = await response.json();

        if (data.status === 'success') {
            console.log('Shoe verified:', data.data);
            // Show shoe details to the user
        } else {
            console.log('Error:', data.message);
            // Handle case where shoe is not found
        }
    } catch (error) {
        console.error('Error verifying shoe:', error);
        // Handle network or other errors
    }
}
```

## 4. Security Considerations
- **HTTPS**: Ensure that your backend API is served over HTTPS to encrypt the communication.
- **JWT or API Tokens**: If this verification process is done through a user or admin interface, secure the API with **authentication tokens** (like **JWT**) to prevent unauthorized access.
- **Database Encryption**: If you store sensitive data like serial numbers or models, encrypt these fields in the database as well.

## Conclusion
By using a **UUID** to track shoes and verifying against a **SQL Server** database, you ensure that each shoe has a unique identifier and the data can be securely verified. This approach keeps your system secure, scalable, and easy to manage.
