import { getFirestore, Timestamp } from "firebase-admin/firestore"


const db = getFirestore()
const userRef = db.collection('user')

export async function createMockUpUser() {
    const mockUpUser = {
      blogTitle: "",
      blogURL: "",
      camperID: "S999",
      domain: "iOS",
      isPushOn: true,
      nickname: 'mockup',
      ordinalNumber: 7,
      profileImageURL: "https://w.namu.la/s/62223555ff374704aa337bb299929204693c936dc4cf8d45ec0844b189605b317667a6956e0c50c46c69600a18b652f53f85e3358a66865b8d57b8d7a00ad19c732c11df86798ab7a83de831010b920f26eb7b45736cb858aa2bdc5b8a9770c3",
      signupDate: Timestamp.now(),
      userUUID: "hello2burstcamp"
    }

    const res = await userRef.doc(mockUpUser.userUUID).set(mockUpUser)
    console.log('유저 생성 - ', res.nickname);
}