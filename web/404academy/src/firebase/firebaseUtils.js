import { collection, getDocs } from "firebase/firestore";
import { db } from "./firebaseConfig";

// Verileri çekmek için genel bir yardımcı fonksiyon
export const fetchCollection = async (collectionName) => {
    const querySnapshot = await getDocs(collection(db, collectionName));
    return querySnapshot.docs.map((doc) => ({
        id: doc.id,
        ...doc.data(),
    }));
};
