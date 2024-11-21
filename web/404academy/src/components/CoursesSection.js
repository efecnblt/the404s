import React, { useEffect, useState } from "react";
import { collection, getDocs } from "firebase/firestore";
import { db } from "../firebase/firebaseConfig";

function CoursesSection() {
    const [courses, setCourses] = useState([]);
    const [loading, setLoading] = useState(true);

    // Listeyi karıştırma fonksiyonu (Fisher-Yates Shuffle)
    const shuffleArray = (array) => {
        for (let i = array.length - 1; i > 0; i--) {
            const j = Math.floor(Math.random() * (i + 1));
            [array[i], array[j]] = [array[j], array[i]];
        }
        return array;
    };

    useEffect(() => {
        const fetchAllCourses = async () => {
            try {
                const authorsSnapshot = await getDocs(collection(db, "authors"));
                let allCourses = [];

                for (const authorDoc of authorsSnapshot.docs) {
                    const coursesSnapshot = await getDocs(
                        collection(db, `authors/${authorDoc.id}/courses`)
                    );
                    const authorCourses = coursesSnapshot.docs.map((courseDoc) => ({
                        id: courseDoc.id,
                        authorName: authorDoc.data().name,
                        ...courseDoc.data(),
                    }));
                    allCourses = [...allCourses, ...authorCourses];
                }

                setCourses(shuffleArray(allCourses));
                setLoading(false);
            } catch (error) {
                console.error("Error fetching courses:", error);
                setLoading(false);
            }
        };

        fetchAllCourses();
    }, []);

    if (loading) {
        return <p className="text-center">Loading courses...</p>;
    }

    return (
        <section className="py-12 bg-gray-50">
            <h2 className="text-3xl font-bold text-center mb-6">New Courses</h2>
            <div className="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-4 gap-6 max-w-7xl mx-auto">
                {courses.slice(0,8).map((course) => (
                    <div
                        key={course.id}
                        className="bg-white rounded-lg shadow hover:shadow-md overflow-hidden"
                    >
                        {/* Resim */}
                        <img
                            src={course.image_url || "https://via.placeholder.com/400"}
                            alt={course.name}
                            className="w-full h-40 object-cover"
                        />
                        {/* Kurs Bilgileri */}
                        <div className="p-4">
                            {/* Başlık */}
                            <h3 className="text-lg font-semibold text-gray-800 truncate">
                                {course.name}
                            </h3>
                            {/* Açıklama */}
                            <p className="text-sm text-gray-600 mt-2 line-clamp-2">
                                {course.description}
                            </p>
                            {/* Alt Bilgiler */}
                            <div className="flex items-center justify-between mt-4 text-gray-600 text-sm">
                                <span className="font-medium">{course.authorName}</span>
                                <span className="bg-gray-100 px-2 py-1 rounded text-xs">
                  {course.level}
                </span>
                            </div>
                            <div className="flex items-center justify-between mt-4">
                                <div className="flex items-center text-yellow-500">
                                    <svg
                                        xmlns="http://www.w3.org/2000/svg"
                                        className="h-5 w-5"
                                        viewBox="0 0 20 20"
                                        fill="currentColor"
                                    >
                                        <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.286 3.957a1 1 0 00.95.69h4.16c.969 0 1.371 1.24.588 1.81l-3.374 2.455a1 1 0 00-.364 1.118l1.286 3.957c.3.921-.755 1.688-1.54 1.118l-3.374-2.455a1 1 0 00-1.175 0l-3.374 2.455c-.785.57-1.84-.197-1.54-1.118l1.286-3.957a1 1 0 00-.364-1.118L2.98 9.384c-.783-.57-.38-1.81.588-1.81h4.16a1 1 0 00.95-.69L9.049 2.927z" />
                                    </svg>
                                    <span className="ml-1">{course.rating}</span>
                                </div>
                                {/* Buton */}
                                <button className="bg-purple-600 text-white flex items-center justify-center gap-2 text-sm px-4 py-2 rounded-lg hover:bg-purple-700">
                                    Start Course
                                    <svg
                                        xmlns="http://www.w3.org/2000/svg"
                                        className="h-5 w-5"
                                        viewBox="0 0 20 20"
                                        fill="currentColor"
                                    >
                                        <path
                                            fillRule="evenodd"
                                            d="M10 18a8 8 0 100-16 8 8 0 000 16zm-1.707-8.707a1 1 0 011.414 0L11 10.586V7a1 1 0 112 0v5a1 1 0 01-1 1H7a1 1 0 110-2h3.586l-1.293-1.293a1 1 0 010-1.414z"
                                            clipRule="evenodd"
                                        />
                                    </svg>
                                </button>
                            </div>
                        </div>
                    </div>
                ))}
            </div>

        </section>
    );
}

export default CoursesSection;
