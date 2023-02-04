import { initializeApp, getApps } from 'firebase-admin/app';
import { pubsub, https, logger } from 'firebase-functions';
import { getBlogTitle } from './service/feedAPI.js';
import { updateFeedDB, updateRecommendFeedDB, updateFeedDBWhenSignup } from './service/firestoreManager.js'
import { sendNotification } from './service/apnsManager.js'
import { deleteUserInfo } from './service/withdrawalManager.js'
import { createMockUpUser } from './service/test/mockUpService.js';
import { testYouTakBlog } from './service/test/testRSSParsing.js';
import { testIsAlgorithmFeed } from './service/test/testAlgorithmFeed.js';

// Initialize
if ( !getApps().length ) initializeApp()

export const scheduledUpdateFeedDB = pubsub.schedule('every 30 minutes').timeZone("Asia/Seoul").onRun(async (context) => {
	updateFeedDB()
})

export const scheduledUpdateRecommendFeedDB = pubsub.schedule('every monday 00:00').timeZone("Asia/Seoul").onRun(async (context) => {
	updateRecommendFeedDB()
})

export const updateFeedWithNewUser = https.onCall(async (data, context) => {
	const userUUID = data.userUUID
	const blogURL = data.blogURL
	updateFeedDBWhenSignup(userUUID, blogURL)
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

export const testBlogParsing = https
	.onRequest(async (context) => {
		await testYouTakBlog()
		return {
			isFinish: true
		}
})

export const testCheckAlgorithm = https
	.onRequest(async (context) => {
		await testIsAlgorithmFeed()
		return {
			isFinish: true
		}
})

export const testMessaging = https
.onRequest(async (context) => {
	await sendNotification()
	return {
		isFinish: true
	}
})
