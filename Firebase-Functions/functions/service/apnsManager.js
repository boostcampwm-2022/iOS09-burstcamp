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
    
    if (isCheckBeforeFeed(recentFeed)) {
        return
    }

    const tokens = await Promise.all(
        userUUIDs.map(userUUID => {
        return getFCMToken(userUUID)
    }))
    const validTokens = tokens.filter(fcmToken => fcmToken !== '')

    logger.log('보낼 토큰들을 만들었어요', validTokens)

    sendMessage(validTokens, recentFeed)
}

/**
* Feed가 현재로부터 24시간 이전에 발행된 피드인지 확인한다
* @param {Feed} feed
* @param {Boolean} 24시간 이전에 발행된 피드라면 true 
*/
function isCheckBeforeFeed(feed) {
    const pubDate = feed['pubDate'].toDate()

    const now = new Date(); // 현재 시간
    const utcNow = now.getTime() + (now.getTimezoneOffset() * 60 * 1000); // 현재 시간을 utc로 변환한 밀리세컨드값
    const koreaTimeDiff = 9 * 60 * 60 * 1000; // 한국 시간은 UTC보다 9시간 빠름(9시간의 밀리세컨드 표현)
    const koreaNow = new Date(utcNow + koreaTimeDiff); // utc로 변환된 값을 한국 시간으로 변환시키기 위해 9시간(밀리세컨드)를 더함
    const koreaYesterday = new Date(koreaNow.setDate(koreaNow.getDate() - 1));
    logger.log("pubDate", pubDate)
    logger.log("현재 1일전", koreaYesterday)
    return pubDate <= koreaYesterday
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