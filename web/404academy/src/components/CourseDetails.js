import React, { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import { doc, getDoc } from "firebase/firestore";
import { db } from "../firebase/firebaseConfig";

function CourseDetails() {
    const { courseId } = useParams(); // URL'deki ID'yi al
    const [course, setCourse] = useState(null);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const fetchCourseDetails = async () => {
            try {
                const courseDoc = await getDoc(doc(db, "courses", courseId));
                if (courseDoc.exists()) {
                    setCourse({ id: courseDoc.id, ...courseDoc.data() });
                }
                setLoading(false);
            } catch (error) {
                console.error("Error fetching course details: ", error);
                setLoading(false);
            }
        };

        fetchCourseDetails();
    }, [courseId]);

    if (loading) {
        return <p className="text-center">Loading course details...</p>;
    }

    if (!course) {
        return <p className="text-center">Course not found!</p>;
    }

    return (
        <section className="py-12 bg-white">
            <div className="max-w-4xl mx-auto px-4">
                <h1 className="text-4xl font-bold mb-4">{course.name}</h1>
                <p className="text-gray-600 mb-8">{course.description}</p>
                <div className="bg-gray-100 p-4 rounded-lg">
                    <p className="text-lg font-semibold">Level: {course.level}</p>
                    <p className="text-lg font-semibold">
                        Rating: {course.rating} ({course.ratingCount} reviews)
                    </p>
                    <p className="text-lg font-semibold">Department: {course.department}</p>
                </div>
            </div>
        </section>
    );
}

export default CourseDetails;
