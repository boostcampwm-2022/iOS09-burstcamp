// import { logger } from 'firebase-functions';
import { initializeApp, getApps } from 'firebase-admin/app';
import { deleteFCMToken, getUserFeedsUUIDs, updateUserScrapFeedUUIDs } from './firestoreManager.js'
import { deleteFeedsAndUpdateRecommendFeed, getUserScrapFeedsUUIDs } from './firestoreManager.js'
import { deleteUserUUIDAtScrapFeed, deleteUser } from './firestoreManager.js'

if (!getApps().length) initializeApp()

export async function deleteUserInfo(userUUID) {

    // 1. 유저가 적은 피드의 아이디들을 가져온다.
    const userFeedUUIDs = await getUserFeedsUUIDs(userUUID)
    
    // 2. 내가 쓴 글을 스크랩한 유저의 scrapFeedUUIDs를 업데이트한다.
    await updateUserScrapFeedUUIDs(userFeedUUIDs)

    // 3. 내가 쓴 글을 삭제하고 추천 피드를 업데이트한다.
    deleteFeedsAndUpdateRecommendFeed(userFeedUUIDs)

    // 4. 내가 스크랩한 피드의 아이디들을 가져온다.
    const userScrapFeedUUIDs = await getUserScrapFeedsUUIDs(userUUID)

    // 5. 내가 스크랩한 피드의 scrapUsers 에서 나의 userUUID를 지운다.
    await deleteUserUUIDAtScrapFeed(userUUID, userScrapFeedUUIDs)

    // 6. 유저의 FCM Token을 삭제한다.
    await deleteFCMToken(userUUID)

    // 7. 유저를 삭제한다.
    await deleteUser(userUUID)
}
