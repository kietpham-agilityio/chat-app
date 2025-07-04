# Firebase Notification Server

A simple Node.js + Express backend for sending Firebase Cloud Messaging (FCM) push notifications using Firebase Admin SDK.

## 🚀 Features

- Send push notifications to specific device tokens
- Support for:
  - Title & body
  - Images
  - Custom data
- Easily extendable for:
  - Silent notifications
  - Action buttons
  - Topic or group messaging

---

## 📦 Requirements

- Node.js v14 or later
- Firebase project with FCM enabled
- Firebase service account key

---

## 🛠 Installation

### 1. Install dependencies

```bash
npm install express body-parser firebase-admin
```

### 2. Add Firebase Service Account
- Go to Firebase Console
- Navigate to Project Settings > Service Accounts
- Click Generate new private key
- Rename it to firebase-service-account.json and place it in the project root

## ▶️ Run the server
```bash
melos run server
```
The server will be available at:
http://localhost:3000

## 📤 Send a Notification

### 1. EndPoint
```bash
POST /send-notification
Content-Type: application/json
```

### 2. Request Body Example
```json
{
  "token":"FCMToken",
  "data": {
    "type": "chat.details",
    "accountId": "accountId",
    "accountName": "Name",
    "content": {
      "id": 2,
      "channelKey": "Chat_App_Channel_Key",
      "title": "New Message",
      "body": "Hi",
      "notificationLayout": "Default",
      "actionType": "Default",
      "displayOnForeground": true,
      "displayOnBackground": true,
      "wakeUpScreen": true
    },
    "actionButtons": [
      {
        "key": "REPLY",
        "label": "Reply",
        "requireInputText": true,
        "autoDismissible": true,
        "actionType": "SilentAction"
      }
    ]
  },
  "android": {
    "priority": "high",
    "notification": {
      "sound": "notifications"
    }
  }
}
```
