import { initializeApp, getApps } from 'firebase-admin/app';
import { pubsub, https } from 'firebase-functions';
import { getBlogTitle } from './service/feedAPI.js';
import { updateFeedDB, updateRecommendFeedDB } from './service/firestoreManager.js'
import { sendNotification } from './service/apnsManager.js'

// Initialize
if ( !getApps().length ) initializeApp()

export const scheduledUpdateFeedDB = pubsub.schedule('every 30 minutes').onRun(async (context) => {
	updateFeedDB()
})

export const scheduledUpdateRecommendFeedDB = pubsub.schedule('every monday 00:00').onRun(async (context) => {
	updateRecommendFeedDB()
})

export const fetchBlogTitle = https.onCall(async (data, context) => {
	const blogTitle = await getBlogTitle(data.blogURL)
	return {
		blogTitle: blogTitle
	}
})

export const scheduledSendNotification = pubsub.schedule('every day 12:00').onRun(async (context) => {
	sendNotification()
})

/**
 * 결제가 필요하지만 각 Cloud Scheduler 작업 비용은 월 $0.10(USD)이고 
 * Google 계정당 작업 3개가 무료로 허용되므로 
 * 전체 비용을 감당할 수 있을 것으로 예상할 수 있습니다. 
 * Blaze 가격 계산기 를 사용하여 예상 사용량을 기반으로 비용 추정치를 생성합니다.
 */