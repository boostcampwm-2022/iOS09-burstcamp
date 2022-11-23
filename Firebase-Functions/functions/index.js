import { initializeApp, getApps } from 'firebase-admin/app';
import { pubsub } from 'firebase-functions';
import { updateFeedDB } from './service/firestoreManager.js'

// Initialize
if ( !getApps().length ) initializeApp()

export const scheduledUpdateFeedDB = pubsub.schedule('every 5 minutes').onRun(async (context) => {
	updateFeedDB()
});