import { initializeApp, getApps } from 'firebase-admin/app';
import { getFirestore, Timestamp } from 'firebase-admin/firestore';
import { fetchContent, fetchParsedRSS, fetchParsedRSSList } from './feedAPI.js';
import { logger } from 'firebase-functions';
import { convertURL, isContainBaekJoonLink, isSolvingAlgorithm } from '../util.js';
import firebase from 'firebase-messaging';

if (!getApps().length) initializeApp()
const db = getFirestore()
const userRef = db.collection('user')
const feedRef = db.collection('feed')
const recommendFeedRef = db.collection('recommendFeed')
const fcmTokenRef = db.collection('fcmToken')

export async function updateFeedDB() {
	const userSnapshot = await userRef.get()
	userSnapshot.docs.map(async (doc) => {
		const user = doc.data();
		const blogURL = user['blogURL'];
		if (blogURL === '') { return }
		const rssURL = convertURL(blogURL);
		const parsedRss = await fetchParsedRSS(rssURL);
		await updateFeedDBFromSingleBlog(parsedRss, user);
	})
}

export async function updateFeedDBWhenSignup(userUUID, blogURL) {
	logger.log("회원 가입에 따른 DB Update - Blog URL : ", blogURL);
	const doc = await userRef.doc(userUUID).get();
	const userData = doc.data();
	if (blogURL === '') { return }

	const rssURL = convertURL(blogURL);
	const parsedRss = await fetchParsedRSS(rssURL);
	await updateFeedDBFromSingleBlog(parsedRss, userData);
}

export async function deleteRecommendFeeds() {
	await recommendFeedRef
		.get()
		.then((querySnapshot) => {
			querySnapshot.docs.forEach(async (doc) => {
				logger.log('test', doc.data()['feedUUID'])
				await deleteRecommendFeed(doc.id)
			})
		})
}

/**
 * 1. 기존 추천피드를 삭제합니다.
 * 2. 전체 피드의 FeedUUID를 가져옵니다
 * 3. 각 피드의 최근 일주일 간 ScrapCount를 가져옵니다.
 * 4. scrapCount가 top3인 [FeedUUID]를 리턴합니다.
 * 5. 4의 [FeedUUID]를 추천 피드 DB에 등록합니다
 */

export async function updateRecommendFeedDB() {
	await deleteRecommendFeeds()

	let feedUUIDList = await getFeedUUIDList()
	let feedWeeklyCountList = await getfeedWeeklyCountList(feedUUIDList)
	let topThreeFeedUUIDList = getTopThreeFeedUUIDList(feedWeeklyCountList)
	await updateNewRecommendFeedToDB(topThreeFeedUUIDList)

}

/**
 * 전체 피드의 FeedUUID를 가져옵니다
 * @returns {[String]} FeedUUID 배열을 리턴
 */

async function getFeedUUIDList() {
	const querySnapshot = await feedRef.get()
	return querySnapshot.docs.map((doc) => {
		return doc.data()['feedUUID']
	})
}

/**
 * 각 피드의 최근 일주일간 ScrapCount를 수집합니다.
 * @param {[String]} feedUUIList 
 * @returns {[{feedUUID: String, count: Int}]} 각 피드의 UUID와 최근 일주일 간 count를 리턴
 */

async function getfeedWeeklyCountList(feedUUIDList) {
	let aWeekAgoDate = getLastWeeksDate()
	logger.log("추천 피드 스크랩 카운트 기준 날짜 - ", aWeekAgoDate)
	return await Promise.all(feedUUIDList.map(async (feedUUID) => {
		let weeklyCount = await countScrapUserSinceDate(aWeekAgoDate, feedUUID)
		let feedWeeklyCount = {
			feedUUID: feedUUID,
			count: weeklyCount
		}
		return feedWeeklyCount
	}))
}

/**
 * FeedUUID를 통해 date 로부터 ScrapCount를 수집합니다.
 * @param {Date, String} 
 * @returns {Int} date로 부터 스크랩 count를 리턴
 */

async function countScrapUserSinceDate(date, feedUUID) {
	let timestamp = date
	const scrapUsersRef = feedRef.doc(feedUUID).collection('scrapUsers');
	const query = scrapUsersRef.where('scrapDate', '>=', timestamp);
	const snapshot = await query.count().get();
	return snapshot.data().count
}

/**
 * 지금으로부터 일주일 전 날짜를 구합니다.
 * @returns {Date}
 */

function getLastWeeksDate() {
	var oneWeekAgo = new Date();
	oneWeekAgo.setDate(oneWeekAgo.getDate() - 7);
  return oneWeekAgo
}

/**
 * FeedUUID & count 정보를 가진 객체를 내림차순 정렬합니다.
 * 최상위 3개를 수집합니다. 이 때 count가 0 이면 수집하지 않습니다.
 * @param {[{feedUUID: String, count: Int}]} feedUUID와count객체  
 * @returns {[String]} 새로운 추천피드 [feedUUID]
 */

function getTopThreeFeedUUIDList(feedWeeklyCountList) {
	let recommendFeedCountPolicy = 3
	var topThreeFeedUUIDList = []

	feedWeeklyCountList.sort((a, b) => {
			return b.count - a.count;
	})

	for (var i = 0;  i < feedWeeklyCountList.length; i++ ) {
		if (feedWeeklyCountList[i].count != 0) {
			topThreeFeedUUIDList.push(feedWeeklyCountList[i].feedUUID)
		}
		if (topThreeFeedUUIDList.length == recommendFeedCountPolicy) {
			break
		}
	}
	return topThreeFeedUUIDList
}

/**
 * [feedUUID]를 받아 해당 feedUUID를 불러옵니다.
 * feedUUID를 기반으로 피드 DB에서 피드를 불러옵니다.
 * 불러온 피드를 추천피드에 저장합니다.
 * @param {[String]} feedUUIDList
 */

async function updateNewRecommendFeedToDB(newRecommendFeedUUIDList) {
	newRecommendFeedUUIDList.forEach(async (newFeedUUID) => {
		const newFeedRef =  feedRef.doc(newFeedUUID)
		const doc = await newFeedRef.get();
		const newRecommendFeed = doc.data()
		await recommendFeedRef.doc(newRecommendFeed.feedUUID).set(newRecommendFeed)
	})
}

/**
 * 한 블로그의 RSS에 담겨있는 feed들을 DB에 저장한다.
 * @param {JSON} parsedRSS 
 * @param {User} writer
 */
async function updateFeedDBFromSingleBlog(parsedRSS, writer) {
	logger.log(writer['nickname'])
	logger.log(writer['blogURL'])
	if (parsedRSS.items === undefined) { return }
	await parsedRSS.items.forEach(async (item) => {
		const feedUUID = item.link.hashCode()
		const docRef = feedRef.doc(feedUUID);
		await docRef.get()
			.then(doc => {
				if (doc.exists) {
					logger.log(item.link, 'is already exist')
					return
				}
				createFeedDataIfNeeded(docRef, writer, feedUUID, item)
				logger.log(item.link, 'is created')
			})
	})
}

/**
 * DB에 한 포스트에 대한 정보를 저장한다.
 * @param {FirebaseFirestore.DocumentReference<FirebaseFirestore.DocumentData>} docRef feedData가 담길 Firestore의 doc 레퍼런스
 * @param {User} writer 작성자
 * @param {string} feedUUID feedURL을 hashing한 값
 * @param {JSON} feed RSS를 JSON으로 파싱한 정보
 */
async function createFeedDataIfNeeded(docRef, writer, feedUUID, feed) {
	if (isSolvingAlgorithm(feed.title)) { 
		logger.log("알고리즘 문제라 제외됐습니다. - ", feed.title)
		return
	}

	const feedInfo = await fetchContent(feed.link)
	const content = feedInfo.content
	const thumbnailURL = feedInfo.thumbnailURL

	if (isContainBaekJoonLink(content)) {
		logger.log("알고리즘 문제라 제외됐습니다. - ", feed.title)
		return
	}

	docRef.set({
		// TODO: User db에서 UUID를 찾아 대입해주기
		feedUUID: feedUUID,
		title: unescapeHtml(feed.title),
		pubDate: Timestamp.fromDate(new Date(feed.pubDate)),
		regDate: Timestamp.now(),
		url: feed.link,
		thumbnailURL: thumbnailURL,
		content: content,
		scrapCount: 0,
		writerUUID: writer['userUUID'],
		writerNickname: writer['nickname'],
		writerDomain: writer['domain'],
		writerOrdinalNumber: writer['ordinalNumber'],
		writerCamperID: writer['camperID'],
		writerProfileImageURL: writer['profileImageURL'],
		writerBlogTitle: writer['blogTitle'],
	})
}

function unescapeHtml(text) {
    const str = text
    return str
		.replaceAll('&amp;', '&')
		.replaceAll('&lt;', '<')
		.replaceAll('&gt;', '>')
		.replaceAll('&quot;', '"')
		.replaceAll('&#039;', "'")
	return str
}

/**
 * 유저의 blogURL을 통해 db에서 유저를 찾고, 해당 유저의 UUID를 리턴한다.
 * @param {String} blogURL 유저의 블로그 URL이다. 끝에 '/'이 붙어서 넘어온다.
 * @returns 일치하는 유저의 UUID
 */
export async function getFeedWriterUUID(blogURL) {
	// https://stackoverflow.com/questions/46568142/google-firestore-query-on-substring-of-a-property-value-text-search/52715590#52715590
	logger.log('해당 유저의 blogURL', blogURL)
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
			if (doc.exists) {
				return doc.data()['fcmToken'] 
			} else {
				return ''
			}
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

export async function deleteRecommendFeed(feedUUID) {
	logger.log('지울것들', feedUUID)
	const scrapUsersRef = recommendFeedRef
		.doc(feedUUID)
		.collection('scrapUsers')

	const batch  = db.batch();
	scrapUsersRef
		.get()
		.then((querySnapshot) => {
			querySnapshot.docs.forEach(async (doc) => {
				logger.log('삭제되는것', doc.id);
				batch.delete(doc.ref)
			})
		})
	await batch.commit();

	logger.log('스크랩 유저 삭제 후 feed 삭제')
	await recommendFeedRef
		.doc(feedUUID)
		.delete()
}

export async function deleteFeed(feedUUID) {
	logger.log('지울것들', feedUUID)
	const scrapUsersRef = feedRef
		.doc(feedUUID)
		.collection('scrapUsers')

	const batch  = db.batch();
	scrapUsersRef
		.get()
		.then((querySnapshot) => {
			querySnapshot.docs.forEach(async (doc) => {
				logger.log('삭제되는것', doc.id);
				batch.delete(doc.ref)
			})
		})
	await batch.commit();

	logger.log('스크랩 유저 삭제 후 feed 삭제')
	await feedRef
		.doc(feedUUID)
		.delete()
}

// MARK: 탈퇴

/**
 * FireStore FCM 삭제
 * @param {String} userUUID 
 */
export async function deleteFCMToken(userUUID) {
	logger.log('fcmToken을 삭제중')
	await fcmTokenRef.doc(userUUID).delete().then(() => {
		logger.log('fcmToken 삭제완료')
	})
}

/**
 * 내가 쓴 글 가져오기 - feed 중에서 writerUUID 가 userUUID와 일치하는 피드 UUID 가져오기
 * @param {String} userUUID 
 * @returns 해당 유저가 쓴 글
 */
export async function getUserFeedsUUIDs(userUUID) {
	logger.log('feed에서 유저 가 쓴 글의 정보를 가져온다.', userUUID)
	const querySnapshot = await feedRef
		.where('writerUUID', '==', userUUID)
		.get()

		logger.log('querysnapShot - ', querySnapshot)
	if (querySnapshot.empty) {
		logger.log('유저가 작성한 글이 없다.')
		return
	}
	const feedUUIDs = querySnapshot.docs.map(doc => {
		return doc.data()['feedUUID']
	})
	logger.log('유저가 쓴 글 들: ', feedUUIDs)

	return feedUUIDs
}

/**
 * 내가 쓴 글을 스크랩한 유저의 scrapFeedUUIDs 업데이트
 * @param {[String]} feedUUIDs 
 */
export async function updateUserScrapFeedUUIDs(feedUUIDs) {
	const batch = db.batch();

	logger.log('유저가 쓴 글의 feedUUIDs: ', feedUUIDs)
	logger.log('이 글을 스크랩한 유저를 찾는다.')

	feedUUIDs.forEach(async(feedUUID)=> {
		await userRef
			.where('scrapFeedUUIDs', 'array-contains', feedUUID)
			.get()
			.then((querySnapshot) => {
				logger.log('이 유저들의 스크랩 정보에서')
				querySnapshot.docs.forEach((doc) => {
					const userUUID = doc.data()['userUUID'];
					logger.log('이 유저의 정보에서', doc.data()['nickname'])
					const curFeedUUIDs = doc.data()['scrapFeedUUIDs']
					logger.log('삭제 전 피드들:', curFeedUUIDs)
					const deletedFeedUUIDs = curFeedUUIDs.filter(uuid => uuid != feedUUID)
					logger.log('삭제 후 피드들:', deletedFeedUUIDs)

					const curRef = userRef.doc(userUUID);
					batch.set(curRef, {'scrapFeddUUIDs': deletedFeedUUIDs})
				})
			})
	})

	batch.commit
}

/**
 * 내가 쓴 글들 삭제 후 recommend 재업데이트
 * @param {*} feedUUIDs 
 */
export async function deleteFeedsAndUpdateRecommendFeed(feedUUIDs) {
	logger.log('내가 쓴 글들 삭제 후 recommend 재업데이트')
	await feedUUIDs
		.forEach(async (feedUUID) => {
			await deleteFeed(feedUUID)
		})
	updateRecommendFeedDB()
}

/**
 * 유저가 스크랩한 피드 아이디들을 가져온다.
 * @param {String} userUUID 
 * @returns 유저가 스크랩한 피드들
 */
export async function getUserScrapFeedsUUIDs(userUUID) {
	return userRef
		.doc(userUUID)
		.get()
		.then((doc) => {
			logger.log('스크랩한 피드 아이디들:', doc.data()['scrapFeedUUIDs'])
			return doc.data()['scrapFeedUUIDs']
		})
}

/**
 * 내가 스크랩한 피드의 scrapUsers 에서 나의 userUUID를 지운다.
 * @param {String} userUUID 
 * @param {[String]} feedUUIDs 
 */
export async function deleteUserUUIDAtScrapFeed(userUUID, feedUUIDs) {
	logger.log('나는야 유저', userUUID)
	logger.log('유저가 스크랩 한 글의 feedUUIDs: ', feedUUIDs)

	feedUUIDs.forEach(async(feedUUID) => {
		await feedUpdateTransactionWhenUserWithdrawal(feedUUID, userUUID)
	})
}

async function feedUpdateTransactionWhenUserWithdrawal(feedUUID, userUUID) {
	const feedDocRef = feedRef.doc(feedUUID);
	const scrapUserDocRef = feedDocRef.collection('scrapUsers').doc(userUUID);

	db.runTransaction(async (t) => {
		const feedDoc = await t.get(feedDocRef);
		const newScrapCount = feedDoc.data().scrapCount - 1;

		t.update(feedDocRef, {scrapCount: newScrapCount});
		t.delete(scrapUserDocRef);
	})
}

/**
 * User - ScrapFeed 컬렉션을 지움
 * @param {String} userUUID 
 */
export async function deleteUserScrapFeed(userUUID) {
	logger.log('User - ScrapFeed 지우기', userUUID)

	const userScrapFeedRef = userRef.doc(userUUID).collection('scrapFeeds');
	const query = userScrapFeedRef.orderBy('feedUUID').limit(100)

	return new Promise((resolve, reject) => {
		deleteQueryBatch(db, query, resolve).catch(reject);
	})
}

async function deleteQueryBatch(db, query, resolve) {
	const snapshot = await query.get()

	const batchSize = snapshot.size
	if (batchSize == 0 ) {
		resolve()
		return;
	}

	const batch = db.batch()
	snapshot.docs.forEach((doc) => {
		batch.delete(doc.ref);
	});
	await batch.commit();

	// 재귀적으로 호출하는데, 스택이 넘치지 않도록 프로세스의 다음 tick에서 실행함
	process.nextTick(() => {
		deleteQueryBatch(db, query, resolve)
	})
}

// 3. FireStore User 삭제
/**
 * 유저 삭제
 * @param {*} userUUID 
 */
export async function deleteUser(userUUID) {
	logger.log('유저를 삭제합니다.')
	userRef
		.doc(userUUID)
		.delete()
}