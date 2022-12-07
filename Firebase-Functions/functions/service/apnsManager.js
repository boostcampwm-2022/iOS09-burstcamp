import { logger } from 'firebase-functions/v1';
import { getUsersIsPushOnTrue, getFCMToken, getRecentFeed, getUser } from './firestoreManager.js';
import { getMessaging } from 'firebase-admin/messaging';

/**
 * 1. push알림이 on 되어있는 유저들의 UUID를 가져온다.
 * 2. 가장 최근의 피드를 가져온다.
 * 3. 피드의 작성자를 가져온다.
 * 
 * 4. 유저의 UUID마다 FCM 토큰을 가져온다.
 * 5. Message를 보낸다.
 */
export async function sendNotification() {
    const userUUIDs = await getUsersIsPushOnTrue()
    const recentFeed = await getRecentFeed()
    const writerUUID = recentFeed['writerUUID']
    const writer = await getUser(writerUUID)
    logger.log('작성자에오', writer)

    userUUIDs.forEach(async (userUUID) => {
        const token = await getFCMToken(userUUID)
        logger.log('FCM 토큰이에오', token)
        sendMessage(token, recentFeed, writer)
    })
}

/**
 * 1. 메세지를 만든다.
 * 2. getMessaging().send(message)
 * @param {String} token 
 * @param {Feed} feed 
 * @param {User} writer 
 */
export async function sendMessage(token, feed, writer) {
    const message = makeMessage(token, feed, writer)
    const messaging = getMessaging()
    messaging.send(message)
    .then((response) => {
        logger.log('어디로 보냈니? token: ' + token)
        logger.log(response.successCount + '개 전송 성공');
    })    
    .catch((error) => {
        logger.log('실패')
    })
}

/**
 * apns message 생성
 */
function makeMessage(fcmToken, feed, writer) {
    logger.log('Feed 작성자에오, ', writer)
    const title = feed['title']
    const feedUUID = feed['feedUUID']
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