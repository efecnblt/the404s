import React, { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import { doc, getDoc, collection, getDocs } from "firebase/firestore";
import { db } from "../firebase/firebaseConfig";

function InstructorDetail() {
    const { instructorId } = useParams(); // URL'den eğitmen ID'sini al
    const [instructor, setInstructor] = useState(null);
    const [courses, setCourses] = useState([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const fetchInstructorDetails = async () => {
            try {
                // Eğitmen bilgilerini al
                const instructorDoc = await getDoc(doc(db, "authors", instructorId));
                if (instructorDoc.exists()) {
                    setInstructor({ id: instructorDoc.id, ...instructorDoc.data() });

                    // Eğitmenin kurslarını al
                    const coursesSnapshot = await getDocs(
                        collection(db, `authors/${instructorId}/courses`)
                    );
                    const coursesData = coursesSnapshot.docs.map((doc) => ({
                        id: doc.id,
                        ...doc.data(),
                    }));
                    setCourses(coursesData);
                }
                setLoading(false);
            } catch (error) {
                console.error("Error fetching instructor details:", error);
                setLoading(false);
            }
        };

        fetchInstructorDetails();
    }, [instructorId]);

    if (loading) {
        return <p className="text-center">Loading instructor details...</p>;
    }

    if (!instructor) {
        return <p className="text-center">Instructor not found!</p>;
    }

    return (
        <section className="py-12 px-4">
            {/* Eğitmen bilgileri */}
            <div className="text-center mb-8">
                <img
                    src={instructor.image_url}
                    alt={instructor.name}
                    className="w-32 h-32 rounded-full mx-auto mb-4"
                />
                <h1 className="text-4xl font-bold">{instructor.name}</h1>
                <p className="text-gray-500">{instructor.department}</p>
                <p className="text-sm mt-2">
                    Rating: {instructor.rating} | Students: {instructor.studentCount} | Courses: {instructor.courseCount}
                </p>
            </div>

            {/* Eğitmenin kursları */}
            <div className="max-w-6xl mx-auto">
                <h2 className="text-3xl font-bold text-center mb-6">Courses by {instructor.name}</h2>
                {courses.length === 0 ? (
                    <p className="text-center">No courses available.</p>
                ) : (
                    <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                        {courses.map((course) => (
                            <div
                                key={course.id}
                                className="bg-gray-100 p-4 rounded-lg shadow hover:shadow-md"
                            >
                                <h3 className="text-lg font-semibold">{course.name}</h3>
                                <p className="text-sm text-gray-500">{course.description}</p>
                                <p className="mt-2">
                                    Level: {course.level} | Rating: {course.rating} ({course.ratingCount})
                                </p>
                            </div>
                        ))}
                    </div>
                )}
            </div>
        </section>
    );
}

export default InstructorDetail;
