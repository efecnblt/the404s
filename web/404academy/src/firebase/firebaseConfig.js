// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getFirestore } from "firebase/firestore";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
    apiKey: "AIzaSyDNJibxxOYzuP_Fw_JlytjU1sDmRn8tVUE",
    authDomain: "cyberguard-87d6e.firebaseapp.com",
    projectId: "cyberguard-87d6e",
    storageBucket: "cyberguard-87d6e.appspot.com",
    messagingSenderId: "118401270404",
    appId: "1:118401270404:web:915f9841924ce4cde3b8d1",
    measurementId: "G-H89PH1W9WB"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

export { db };