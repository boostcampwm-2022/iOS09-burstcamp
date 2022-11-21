import { initializeApp } from 'firebase-admin/app';
import { getFirestore, Timestamp } from 'firebase-admin/firestore';
import { pubsub, logger, https } from 'firebase-functions';
import { getBlogsByRSSLinkList } from './service/feedAPI.js';
import './util.js';

// Initialize
initializeApp();
const db = getFirestore();

export const scheduledUpdateFeedDB = pubsub.schedule('every 5 minutes').onRun(async (context) => {
	updateFeedDB()
});

export const updateFeedDB = https.onRequest(async (context) => {
	const blogSnapshot = await db.collection('blog').get();
	const rssLinkList = blogSnapshot.docs.map(doc => doc.data()['blogRSSLink']);
	const blogRSSLinkList = await getBlogsByRSSLinkList(rssLinkList);
	blogRSSLinkList.forEach(blogRSSLink => updateBlogDatabase(blogRSSLink));
});

async function updateBlogDatabase(blogRSS) {
	const blogUUID = blogRSS.feed.link.hashCode();
	await blogRSS.items.forEach(async (item) => {
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

async function createFeedDataIfNeeded(docRef, blogUUID, feed) {
	docRef.set({
		// writerUUID: writerUUID,
		blogUUID: blogUUID,
		pub_date: Timestamp.fromDate(new Date(feed.pubDate)),
		link: feed.link,
		thumbnail: feed.thumbnail,
		content: feed.content,
	});
}
