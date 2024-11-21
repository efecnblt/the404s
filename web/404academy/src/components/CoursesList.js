import React, { useEffect, useState } from "react";
import { collection, getDocs } from "firebase/firestore";
import { db } from "../firebase/firebaseConfig";
import { useParams, Link } from "react-router-dom";

function CoursesList() {
    const { authorId } = useParams();
    const [courses, setCourses] = useState([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const fetchCourses = async () => {
            try {
                const querySnapshot = await getDocs(
                    collection(db, `authors/${authorId}/courses`)
                );
                const coursesData = querySnapshot.docs.map((doc) => ({
                    id: doc.id,
                    ...doc.data(),
                }));
                setCourses(coursesData);
                setLoading(false);
            } catch (error) {
                console.error("Error fetching courses: ", error);
                setLoading(false);
            }
        };

        fetchCourses();
    }, [authorId]);

    if (loading) {
        return <p className="text-center">Loading courses...</p>;
    }

    return (
        <section className="py-12 bg-gray-50">
            <h2 className="text-3xl font-bold text-center mb-6">Courses</h2>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6 max-w-6xl mx-auto">
                {courses.map((course) => (
                    <div key={course.id} className="bg-white p-4 rounded-lg shadow hover:shadow-md">
                        <h3 className="text-lg font-semibold">{course.name}</h3>
                        <p>{course.description}</p>
                        <p className="text-sm text-gray-500">Level: {course.level}</p>
                        <Link
                            to={`/authors/${authorId}/courses/${course.id}`}
                            className="mt-4 inline-block bg-purple-600 text-white px-4 py-2 rounded hover:bg-purple-700"
                        >
                            View Details
                        </Link>
                    </div>
                ))}
            </div>
        </section>
    );
}

export default CoursesList;
