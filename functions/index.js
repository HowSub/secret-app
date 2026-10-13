const { onValueCreated } = require("firebase-functions/v2/database");
const { initializeApp } = require("firebase-admin/app");
const { getDatabase } = require("firebase-admin/database");
const { getMessaging } = require("firebase-admin/messaging");

initializeApp();

exports.onNewMessage = onValueCreated({
  ref: "/chats/{chatRoomId}/{messageId}",
  region: "europe-west1" 
}, async (event) => {
  const messageData = event.data.val();
  const senderId = messageData.senderId;
  const text = messageData.text;
  const chatRoomId = event.params.chatRoomId;

  const uids = chatRoomId.split("_");
  const recipientId = uids.find(uid => uid !== senderId);

  if (!recipientId) return;

  try {
    const db = getDatabase();

    const senderSnapshot = await db.ref(`users/${senderId}`).get();
    const senderName = senderSnapshot.exists() ? (senderSnapshot.val().name || "User") : "User";

    const recipientSnapshot = await db.ref(`users/${recipientId}/fcmToken`).get();
    if (!recipientSnapshot.exists()) {
      console.log("У получателя нет токена: " + recipientId);
      return;
    }
    const fcmToken = recipientSnapshot.val();
    
    const message = {
      notification: {
        title: senderName,
        body: text
      },
      token: fcmToken
    };

    await getMessaging().send(message);
    console.log("Уведомление успешно отправлено для: " + recipientId);

  } catch (error) {
    console.error("Ошибка при отправке пуша: ", error);
  }
});
