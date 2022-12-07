import { logger } from 'firebase-functions/v1';
import { getUsersIsPushOnTrue, getFCMToken, getRecentFeed, getUser } from './firestoreManager.js';
import { getMessaging } from 'firebase-admin/messaging';

/**
 * apns 전송
 */
export async function sendNotification() {
    const userUUIDs = await getUsersIsPushOnTrue()
    const recentFeed = await getRecentFeed()
    const writerUUID = recentFeed['writerUUID']
    const writer = await getUser(writerUUID)
    logger.log('작성자에오', writer)

    userUUIDs.forEach(async (userUUID) => {
        const token = await getFCMToken(userUUID)
        logger.log('토큰이에오', token)
        sendMessage(token, recentFeed, writer)
    })
}

export async function sendMessage(token, feed, writer) {
    const message = makeMessage(token, feed, writer)
    const messaging = getMessaging()
    messaging.send(message)
    .then((response) => {
        logger.log('어디로 보냈니 ' + token)
        logger.log(response.successCount + ' 개 성공');
    })    
    .catch((error) => {
        logger.log('실패')
    })
}

/**
 * apns message 생성]
 */
function makeMessage(fcmToken, feed, writer) {
    logger.log('여강겨아', writer)
    const title = feed['title']
    const feedUUID = feed['feedUUID']
    const domain = writer['domain']
    const nickname = writer['nickname']
    const body = title + ' 📣 by ' + nickname

    const message = {
        notification: {
            title: '오늘의 피드를 확인해보세요 💙',
            body: body
        },
        data: { feedUUID: feedUUID },
        token: fcmToken
    }
    return message
}