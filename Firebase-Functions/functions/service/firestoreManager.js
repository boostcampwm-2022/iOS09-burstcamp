import { initializeApp, getApps } from 'firebase-admin/app';
import { getFirestore, Timestamp } from 'firebase-admin/firestore';
import { fetchContent, fetchParsedRSSList } from './feedAPI.js';
import { logger } from 'firebase-functions';
import { convertURL } from '../util.js';
import { sendMessage } from './apnsManager.js';

if (!getApps().length) initializeApp()
const db = getFirestore()
const userRef = db.collection('user')
const feedRef = db.collection('feed')
const recommendFeedRef = db.collection('recommendFeed')
const fcmTokenRef = db.collection('fcmToken')

export async function updateFeedDB() {
	const userSnapshot = await userRef.get()
	const rssURLList = userSnapshot.docs.map(doc => {
		const blogURL = doc.data()['blogURL']
		const rssURL = convertURL(blogURL)
		return rssURL
	})
	const parsedRSSList = await fetchParsedRSSList(rssURLList)
	parsedRSSList.forEach(parsedRSS => updateFeedDBFromSingleBlog(parsedRSS))
}

export async function updateRecommendFeedDB() {
	await feedRef
		.orderBy('pubDate', 'desc')
		.limit(3)
		.get()
		.then((querySnapshot) => {
			querySnapshot.docs.forEach(async (doc) => {
				await recommendFeedRef.add(doc.data())
			})
		})
}

/**
 * 한 블로그의 RSS에 담겨있는 feed들을 DB에 저장한다.
 * @param {JSON} parsedRSS 
 */
async function updateFeedDBFromSingleBlog(parsedRSS) {
	const blogURL = parsedRSS.feed.link
	const writerUUID = await getFeedWriterUUID(blogURL)
	await parsedRSS.items.forEach(async (item) => {
		const feedUUID = item.link.hashCode()
		const docRef = feedRef.doc(feedUUID);
		await docRef.get()
			.then(doc => {
				if (doc.exists) {
					logger.log(item.link, 'is already exist')
					return
				}
				createFeedDataIfNeeded(docRef, writerUUID, feedUUID, item)
				logger.log(item.link, 'is created')
			})
	})
}

/**
 * DB에 한 포스트에 대한 정보를 저장한다.
 * @param {FirebaseFirestore.DocumentReference<FirebaseFirestore.DocumentData>} docRef feedData가 담길 Firestore의 doc 레퍼런스
 * @param {String} writerUUID 작성자의 UUID 값
 * @param {string} feedUUID feedURL을 hashing한 값
 * @param {JSON} feed RSS를 JSON으로 파싱한 정보
 */
async function createFeedDataIfNeeded(docRef, writerUUID, feedUUID, feed) {
	const content = await fetchContent(feed.link)
	docRef.set({
		// TODO: User db에서 UUID를 찾아 대입해주기
		feedUUID: feedUUID,
		writerUUID: writerUUID,
		title: feed.title,
		url: feed.link,
		thumbnail: feed.thumbnail,
		content: content,
		pubDate: Timestamp.fromDate(new Date(feed.pubDate)),
		regDate: Timestamp.now(),
	})
}

/**
 * 유저의 blogURL을 통해 db에서 유저를 찾고, 해당 유저의 UUID를 리턴한다.
 * @param {String} blogURL 유저의 블로그 URL이다. 끝에 '/'이 붙어서 넘어온다.
 * @returns 일치하는 유저의 UUID
 */
export async function getFeedWriterUUID(blogURL) {
	// https://stackoverflow.com/questions/46568142/google-firestore-query-on-substring-of-a-property-value-text-search/52715590#52715590
	return userRef
		.where('blogURL', '>=', blogURL.slice(0, -1))
		.where('blogURL', '<=', blogURL)
		.limit(1)
		.get()
		.then((querySnapshot) => {
			return querySnapshot.docs.at(0).id
		})
}

/**
 * @returns 푸시알림이 on 되어있는 유저의 UUID들
 */
export async function getUsersIsPushOnTrue() {
	const users = await userRef
		.where('isPushOn', '==', true)
		.get()

	const userUUIDs = []
	users.forEach((doc) => {
		userUUIDs.push(doc.data()['userUUID'])
	})

	return userUUIDs
}

/**
 * userUUID로 FCM Token을 찾는다.
 * @param {String} userUUID 
 * @returns userUUID에 해당하는 FCM Token
 */
export async function getFCMToken(userUUID) {
	logger.log('유저 아이디' + userUUID);
	return fcmTokenRef
		.doc(userUUID)
		.get()
		.then((doc) => {
			return doc.data()['fcmToken'] 
		})
}

/**
 * userUUID로 User를 찾는다.
 * @param {String} userUUID 
 * @returns user
 */
export async function getUser(userUUID) {
	return userRef
		.doc(userUUID)
		.get()
		.then((doc) => {
			return doc.data()
		})
}

/**
 * @returns 가장 최근의 Feed
 */
export async function getRecentFeed() {
	return await feedRef
		.orderBy('pubDate', 'desc')
		.limit(1)
		.get()
		.then((querySnapshot) => {
			return querySnapshot.docs.at(0).data()
		})
}

