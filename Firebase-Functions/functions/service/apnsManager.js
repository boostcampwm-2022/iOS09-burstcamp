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

    const tokens = await Promise.all(
        userUUIDs.map(userUUID => {
        return getFCMToken(userUUID)
    }))
    const validTokens = tokens.filter(fcmToken => fcmToken !== '')

    logger.log('보낼 토큰들을 만들었어요', validTokens)

    sendMessage(validTokens, recentFeed)
}


/**
* 메세지를 한번에 모든 token에게 보낸다.
* @param {[String]} token 
* @param {Feed} feed 
*/
export async function sendMessage(tokens, feed) {
    logger.log('실행하는중~~~~~~~')
    const message = makeMessage(tokens, feed)
    const messaging = getMessaging()
    messaging.sendMulticast(message)
    .then((response) => {
        logger.log('어디로 보냈니? tokens: ' + tokens)
        logger.log(response.successCount + '개 전송 성공');
    })    
    .catch((error) => {
        logger.log('실패')
    })
}

/**
* 1. 메세지를 만든다.
* 2. getMessaging().send(message)
* @param {[String]} token 
* @param {Feed} feed 
* @param {User} writer 
*/
function makeMessage(fcmTokens, feed) {
        logger.log('Feed 작성자에오, ', feed.writerNickname)
        const title = feed['title']
        const feedUUID = feed['feedUUID']
        const nickname = feed['writerNickname']
        const body = title + ' 📣 by ' + nickname
    
        const message = {
            notification: {
                title: '오늘의 최신 피드를 확인해보세요 💙',
                body: body
            },
            data: { feedUUID: feedUUID },
            tokens: fcmTokens,
            apns: {
                headers: {
                    'apns-priority': '10',
                },
                payload: {
                    aps: {
                        sound: 'default',
                    }
                },
            },
        }
        return message
    }