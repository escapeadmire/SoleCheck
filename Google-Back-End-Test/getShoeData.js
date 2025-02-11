const functions = require('@google-cloud/functions-framework');
const admin = require('firebase-admin');

admin.initializeApp(); // Initialize Firebase Admin SDK

const db = admin.firestore(); // Get Firestore instance

functions.http('getShoeData', async (req, res) => {
  const serialNumber = req.params.serialNumber; // Get serial number from URL parameter

  try {
    const shoeDoc = await db.collection('shoes').doc(serialNumber).get();

    if (!shoeDoc.exists) {
      res.status(404).send('Shoe not found'); // Send 404 if not found
      return;
    }

    const shoeData = shoeDoc.data(); // Get the shoe data

    res.json(shoeData); // Send the data as JSON

  } catch (error) {
    console.error('Error fetching shoe data:', error);
    res.status(500).send('Internal Server Error'); // Send 500 on error
  }
});
