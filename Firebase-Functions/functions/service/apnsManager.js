import { getFCMTokens, getRecentFeed } from './firestoreManager.js'

/**
 * apns 전송
 */
export async function sendNotification() {
    const fcmTokens = await getFCMTokens()
    const recentFeed = await recentFeed()
    const message = makeMessage(fcmTokens, recentFeed)

    getMessaging().sendMulticast(message)
        .then((response) => {
            logger.log('send apns to ' + fcmTokens)
            logger.log(response.successCount + ' messages were sent successfully');
        })
}

/**
 * apns message 생성
 * @param {[String]} fcmTokens push가 켜져있는 유저의 fcm Token들
 * @param {doc.data()} feed 가장 최근 Feed의 doc data
 * @returns notification message
 */
function makeMessage(fcmTokens, feed) {
    const message = {
        notification: {
            title: 'burstcamp',
            body: feed['title']
        },
        data: { feedUUID: 'asddqwdqwasdasdasd' },
        tokens: fcmTokens
    }
    return message
}