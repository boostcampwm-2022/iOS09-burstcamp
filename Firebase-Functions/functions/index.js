import { initializeApp, getApps } from 'firebase-admin/app';
import { pubsub, https } from 'firebase-functions';
import { getBlogTitle } from './service/feedAPI.js';
import { updateFeedDB, updateRecommendFeedDB, deleteRecommendFeeds } from './service/firestoreManager.js'
import { sendNotification } from './service/apnsManager.js'
import { deleteUserInfo } from './service/withdrawalManager.js'
import { createMockUpUser } from './service/test/mockUpService.js';

// Initialize
if ( !getApps().length ) initializeApp()

export const scheduledUpdateFeedDB = pubsub.schedule('every 30 minutes').onRun(async (context) => {
	updateFeedDB()
})

export const scheduledUpdateRecommendFeedDB = pubsub.schedule('every monday 00:00').onRun(async (context) => {
	updateRecommendFeedDB()
})

export const updateFeedDBWhenSignup = https.onCall(async (context) => {
	updateFeedDB()
})

export const fetchBlogTitle = https.onCall(async (data, context) => {
	const blogTitle = await getBlogTitle(data.blogURL)
	return {
		blogTitle: blogTitle
	}
})

export const deleteUser = https
	.onCall(async (data, context) => {
		await deleteUserInfo(data.userUUID)
		return {
			isFinish: true
		}
	})

export const scheduledSendNotification = pubsub.schedule('every day 12:16').timeZone("Asia/Seoul")
.onRun(async (context) => {
	sendNotification()
})

export const createMockUpUserToFirestore  = https.onRequest(async (context) => {
	createMockUpUser()
})

export const deleteMockUpUser = https
	.onRequest(async (context) => {
		await deleteUserInfo('hello2burstcamp')
		return {
			isFinish: true
		}
	})