import { initializeApp, getApps } from 'firebase-admin/app';
import { getFirestore, Timestamp } from 'firebase-admin/firestore';
import { fetchContent, fetchParsedRSSList } from './feedAPI.js';
import { logger } from 'firebase-functions';
import '../util.js';

if ( !getApps().length ) initializeApp()
const db = getFirestore();

export async function updateFeedDB() {
	const blogSnapshot = await db.collection('blog').get();
	const rssURLList = blogSnapshot.docs.map(doc => doc.data()['rssURL']);
	const parsedRSSList = await fetchParsedRSSList(rssURLList);
	parsedRSSList.forEach(parsedRSS => updateFeedDBFromSingleBlog(parsedRSS));
}

/**
 * 한 블로그의 RSS에 담겨있는 feed들을 DB에 저장한다.
 * @param {JSON} parsedRSS 
 */
async function updateFeedDBFromSingleBlog(parsedRSS) {
	const blogUUID = parsedRSS.feed.link.hashCode();
	await parsedRSS.items.forEach(async (item) => {
		const feedUUID = item.link.hashCode()
		const docRef = db.collection('feed').doc(feedUUID);
		await docRef.get()
			.then(doc => {
				if (doc.exists) {
					logger.log(item.link, 'is already exist');
					return;
				}
				createFeedDataIfNeeded(docRef, blogUUID, item);
				logger.log(item.link, 'is created');
			});
	});
}

/**
 * DB에 한 포스트에 대한 정보를 저장한다.
 * @param {FirebaseFirestore.DocumentReference<FirebaseFirestore.DocumentData>} docRef feedData가 담길 Firestore의 doc 레퍼런스
 * @param {string} blogUUID blogURL을 hashing한 값
 * @param {JSON} feed RSS를 JSON으로 파싱한 정보
 */
async function createFeedDataIfNeeded(docRef, blogUUID, feed) {
	const content = await fetchContent(feed.link)
	docRef.set({
		// writerUUID: writerUUID,
		blogUUID: blogUUID,
		title: feed.title,
		url: feed.link,
		thumbnail: feed.thumbnail,
		content: content,
		pubDate: Timestamp.fromDate(new Date(feed.pubDate)),
		regDate: Timestamp.now(),
	});
}
