import React, { useEffect, useState } from "react";
import { collection, getDocs } from "firebase/firestore";
import { db } from "../firebase/firebaseConfig";

function TopCoursesSection() {
    const [courses, setCourses] = useState([]);
    const [currentIndex, setCurrentIndex] = useState(0);
    const visibleCourses = 6;

    useEffect(() => {
        const fetchTopCourses = async () => {
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

                // Sadece ilk 10 kursu alalım (örneğin, en yüksek rating'e göre)
                const sortedCourses = allCourses.sort((a, b) => b.rating - a.rating).slice(0, 10);
                setCourses(sortedCourses);
            } catch (error) {
                console.error("Error fetching top courses:", error);
            }
        };

        fetchTopCourses();
    }, []);

    const handleNext = () => {
        if (currentIndex + visibleCourses < courses.length) {
            setCurrentIndex(currentIndex + 1);
        }
    };

    const handlePrev = () => {
        if (currentIndex > 0) {
            setCurrentIndex(currentIndex - 1);
        }
    };


    return (
        <section className="py-12 bg-white">
            <div className="max-w-7xl mx-auto px-4">
                <div className="flex justify-between items-center mb-6">
                    <h2 className="text-3xl font-bold">Top Courses</h2>
                    <div className="flex gap-2">
                        <button
                            onClick={handlePrev}
                            disabled={currentIndex === 0}
                            className={`p-2 rounded-full shadow-lg bg-gray-200 hover:bg-gray-300 ${
                                currentIndex === 0 && "opacity-50 cursor-not-allowed"
                            }`}
                        >
                            <svg
                                xmlns="http://www.w3.org/2000/svg"
                                className="h-5 w-5"
                                fill="none"
                                viewBox="0 0 24 24"
                                stroke="currentColor"
                                strokeWidth={2}
                            >
                                <path
                                    strokeLinecap="round"
                                    strokeLinejoin="round"
                                    d="M15 19l-7-7 7-7"
                                />
                            </svg>
                        </button>
                        <button
                            onClick={handleNext}
                            disabled={currentIndex + visibleCourses >= courses.length}
                            className={`p-2 rounded-full shadow-lg bg-gray-200 hover:bg-gray-300 ${
                                currentIndex + visibleCourses >= courses.length &&
                                "opacity-50 cursor-not-allowed"
                            }`}
                        >
                            <svg
                                xmlns="http://www.w3.org/2000/svg"
                                className="h-5 w-5"
                                fill="none"
                                viewBox="0 0 24 24"
                                stroke="currentColor"
                                strokeWidth={2}
                            >
                                <path
                                    strokeLinecap="round"
                                    strokeLinejoin="round"
                                    d="M9 5l7 7-7 7"
                                />
                            </svg>
                        </button>
                    </div>
                </div>

                <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-3 xl:grid-cols-3 gap-6">
                    {courses.slice(currentIndex, currentIndex + visibleCourses).map((course) => (
                        <div
                            key={course.id}
                            className="bg-white rounded-lg shadow hover:shadow-md overflow-hidden"
                        >
                            <img
                                src={course.image_url || "https://via.placeholder.com/400"}
                                alt={course.name}
                                className="w-full h-40 object-cover"
                            />
                            <div className="p-4">
                                <h3 className="text-lg font-semibold text-gray-800 truncate">
                                    {course.name}
                                </h3>
                                <p className="text-sm text-gray-600 mt-2 line-clamp-2">
                                    {course.description}
                                </p>
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
                                            <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.286 3.957a1 1 0 00.95.69h4.16c.969 0 1.371 1.24.588 1.81l-3.374 2.455a1 1 0 00-.364 1.118l1.286 3.957c.3.921-.755 1.688-1.54 1.118l-3.374-2.455a1 1 0 00-1.175 0l-3.374-2.455c-.785.57-1.84-.197-1.54-1.118l1.286-3.957a1 1 0 00-.364-1.118L2.98 9.384c-.783-.57-.38-1.81.588-1.81h4.16a1 1 0 00.95-.69L9.049 2.927z" />
                                        </svg>
                                        <span className="ml-1">{course.rating}</span>
                                    </div>
                                    <button className="bg-purple-600 text-white flex items-center justify-center gap-2 text-sm px-4 py-2 rounded-lg hover:bg-purple-700">
                                        Start Course
                                    </button>
                                </div>
                            </div>
                        </div>
                    ))}
                </div>
            </div>
        </section>
    );
}

export default TopCoursesSection;
