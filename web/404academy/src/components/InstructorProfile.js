import React, { useEffect, useState } from "react";
import { useParams, Link, useNavigate } from "react-router-dom";
import { doc, getDoc, collection, getDocs } from "firebase/firestore";
import { db } from "../firebase/firebaseConfig";
import DOMPurify from "dompurify";
import { FaStar } from "react-icons/fa"; // For star icons

function InstructorProfile() {
    const { instructorId } = useParams();
    const navigate = useNavigate();
    const [instructor, setInstructor] = useState(null);
    const [courses, setCourses] = useState([]);
    const [loading, setLoading] = useState(true);
    const [showFullDescription, setShowFullDescription] = useState(false);

    useEffect(() => {
        const fetchInstructorDetails = async () => {
            try {
                const instructorDoc = await getDoc(doc(db, "authors", instructorId));
                if (instructorDoc.exists()) {
                    setInstructor({ id: instructorDoc.id, ...instructorDoc.data() });

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
                console.error("Error fetching instructor details: ", error);
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

    const renderStars = (rating) => {
        const totalStars = 5;
        const filledStars = Math.floor(rating);
        const emptyStars = totalStars - filledStars;

        return (
            <div className="flex items-center">
                {[...Array(filledStars)].map((_, i) => (
                    <FaStar key={`filled-${i}`} className="text-yellow-500" />
                ))}
                {[...Array(emptyStars)].map((_, i) => (
                    <FaStar key={`empty-${i}`} className="text-gray-300" />
                ))}
            </div>
        );
    };

    const toggleDescription = () => {
        setShowFullDescription(!showFullDescription);
    };

    const truncatedDescription =
        instructor.description.length > 300
            ? instructor.description.substring(0, 300) + "..."
            : instructor.description;

    return (
        <section className="py-12 bg-gray-50">
            <div className="max-w-7xl mx-auto px-4">
                {/* Main Content */}
                <div className="flex flex-col md:flex-row gap-8">
                    {/* Left Column */}
                    <div className="md:w-1/3 bg-white p-6 rounded-lg shadow-lg">
                        <div className="text-center mb-6">
                            <img
                                src={instructor.image_url || "https://via.placeholder.com/150"}
                                alt={instructor.name}
                                className="w-32 h-32 mx-auto rounded-full object-cover mb-4"
                            />
                            <h1 className="text-2xl font-bold">{instructor.name}</h1>
                            <p className="text-gray-500">{instructor.department}</p>
                        </div>
                        {/* Stats */}
                        <div className="space-y-4">
                            {/* Total Students */}
                            <div className="flex items-center">
                <span className="text-3xl font-bold text-purple-600 mr-3">
                  {instructor.studentCount}
                </span>
                                <p className="text-base font-medium text-gray-600">
                                    Total Students
                                </p>
                            </div>
                            {/* Courses */}
                            <div className="flex items-center">
                <span className="text-3xl font-bold text-blue-600 mr-3">
                  {courses.length}
                </span>
                                <p className="text-base font-medium text-gray-600">Courses</p>
                            </div>
                            {/* Rating */}
                            <div className="flex items-center">
                                {renderStars(instructor.rating)}
                                <span className="text-xl font-bold text-yellow-600 ml-2">
                  {instructor.rating}
                </span>
                            </div>
                        </div>
                        {/* Back Button */}
                        <div className="mt-8 text-center">
                            <button
                                onClick={() => navigate(-1)}
                                className="bg-purple-600 text-white px-6 py-3 rounded-lg text-sm hover:bg-purple-700"
                            >
                                Back to Instructors
                            </button>
                        </div>
                    </div>
                    {/* Right Column */}
                    <div className="md:w-2/3">
                        {/* Description */}
                        <div className="bg-white p-6 rounded-lg shadow-lg mb-8">
                            <h2 className="text-xl font-bold mb-4">
                                About {instructor.name}
                            </h2>
                            <div
                                className="prose max-w-none"
                                dangerouslySetInnerHTML={{
                                    __html: DOMPurify.sanitize(
                                        showFullDescription
                                            ? instructor.description
                                            : truncatedDescription
                                    ),
                                }}
                            ></div>
                            {instructor.description.length > 300 && (
                                <button
                                    onClick={toggleDescription}
                                    className="mt-4 text-purple-600 hover:underline"
                                >
                                    {showFullDescription ? "Show Less" : "Show More"}
                                </button>
                            )}
                        </div>
                        {/* Courses */}
                        <div>
                            <h2 className="text-2xl font-bold mb-6">
                                Courses
                            </h2>
                            <div className="grid grid-cols-1 sm:grid-cols-2 gap-6">
                                {courses.map((course) => (
                                    <Link
                                        to={`/course/${course.id}`}
                                        key={course.id}
                                        className="bg-white rounded-lg shadow hover:shadow-md p-4"
                                    >
                                        <h3 className="text-lg font-semibold">{course.name}</h3>
                                        <p className="text-sm text-gray-500">
                                            {course.description}
                                        </p>
                                    </Link>
                                ))}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    );
}

export default InstructorProfile;
