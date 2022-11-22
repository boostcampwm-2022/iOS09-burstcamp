import { initializeApp, getApps } from 'firebase-admin/app';
import { pubsub } from 'firebase-functions';
import { updatePostDB } from './service/firestoreManager.js'

// Initialize
if ( !getApps().length ) initializeApp()

export const scheduledUpdatePostDB = pubsub.schedule('every 5 minutes').onRun(async (context) => {
	updatePostDB()
});