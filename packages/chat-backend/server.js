const express = require("express");
const admin = require("firebase-admin");
const bodyParser = require("body-parser");

// Import service account key
const serviceAccount = require("./firebase-service-account.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const app = express();
const port = 3000;

// Middleware read JSON from body request
app.use(bodyParser.json());

// Endpoint send notification
app.post("/send-notification", async (req, res) => {
  const body = req.body;

  if (!body || !body.token) {
    return res.status(400).send("Missing required field: token");
  }

  const data = body.data || {};

  // Convert content and actionButtons to string if they're objects
  if (data.content && typeof data.content !== "string") {
    data.content = JSON.stringify(data.content);
  }

  if (data.actionButtons && typeof data.actionButtons !== "string") {
    data.actionButtons = JSON.stringify(data.actionButtons);
  }

  const payload = {
    token: body.token,
    data,
    android: body.android ?? {},
    apns: body.apns ?? {},
  };

  console.log("🔥 Final payload:", JSON.stringify(payload, null, 2));

  try {
    const response = await admin.messaging().send(payload);
    res.status(200).send({ success: true, response });
  } catch (error) {
    console.error("❌ Error sending notification:", error);
    res.status(500).send({ success: false, error: error.message });
  }
});

// Start server
app.listen(port, () => {
  console.log(`🚀 Server is running at http://localhost:${port}`);
});
