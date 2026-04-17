const { onDocumentDeleted } = require("firebase-functions/v2/firestore");
const { initializeApp } = require("firebase-admin/app");
const { getAuth } = require("firebase-admin/auth");

initializeApp();

const collections = ["patients", "doctors", "admins"];

collections.forEach((col) => {
  exports[`onDelete_${col}`] = onDocumentDeleted(`${col}/{userId}`, async (event) => {
    const uid = event.params.userId;
    try {
      await getAuth().deleteUser(uid);
      console.log(`Deleted auth user ${uid} from ${col}`);
    } catch (err) {
      if (err.code !== "auth/user-not-found") {
        console.error(`Failed to delete auth user ${uid}:`, err);
      }
    }
  });
});
