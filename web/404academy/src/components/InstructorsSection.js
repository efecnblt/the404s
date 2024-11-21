import React, { useEffect, useState } from "react";
import { collection, getDocs } from "firebase/firestore";
import { db } from "../firebase/firebaseConfig";
import { Link } from "react-router-dom"; // Router'dan Link kullanımı

function InstructorsSection() {
    const [instructors, setInstructors] = useState([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const fetchInstructors = async () => {
            try {
                const querySnapshot = await getDocs(collection(db, "authors"));
                const instructorsData = querySnapshot.docs.map((doc) => ({
                    id: doc.id,
                    ...doc.data(),
                }));
                setInstructors(instructorsData);
                setLoading(false);
            } catch (error) {
                console.error("Error fetching instructors: ", error);
                setLoading(false);
            }
        };

        fetchInstructors();
    }, []);

    if (loading) {
        return <p className="text-center">Loading instructors...</p>;
    }

    return (
        <section className="py-12 bg-white">
            <div className="max-w-7xl mx-auto px-4 flex flex-col lg:flex-row items-center lg:items-start gap-8">
                {/* Sol Bölüm: Yazı ve Buton */}
                <div className="lg:w-1/3 text-center lg:text-left">
                    <h2 className="text-4xl font-bold mb-4">
                        <span className="text-purple-600">Best</span> Instructors
                    </h2>
                    <p className="text-gray-600 mb-6">
                        At The Academy, We Strive To Bring Together The Best Professors For
                        The Best Courses
                    </p>
                    <div className="flex flex-col items-center lg:items-start gap-4">
                        <button
                            className="bg-black text-white px-6 py-3 rounded-lg text-sm hover:bg-gray-800 flex items-center gap-2">
                            All Instructors
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
                        <span className="text-purple-600 bg-purple-50 px-4 py-2 rounded-full text-sm">
              {instructors.length} Instructors
            </span>
                    </div>
                </div>
                {/* Sağ Bölüm: Eğitmenler */}
                <div
                    className="lg:w-2/3 bg-purple-50 rounded-lg p-6 grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6">
                    {instructors.slice(0, 6).map((instructor) => (
                        <Link
                            to={`/instructor/${instructor.id}`}
                            key={instructor.id}
                            className="bg-white rounded-lg shadow hover:shadow-md p-4 text-center"
                        >
                            <img
                                src={instructor.image_url || "https://via.placeholder.com/150"}
                                alt={instructor.name}
                                className="w-24 h-24 mx-auto rounded-full object-cover mb-4"
                            />
                            <h3 className="text-lg font-semibold text-gray-800">
                                {instructor.name}
                            </h3>
                            <p className="text-sm text-gray-500">{instructor.department}</p>
                        </Link>
                    ))}
                </div>

            </div>
            <section className="py-12 bg-white">
                <div
                    className="max-w-7xl mx-auto px-4 flex flex-col lg:flex-row items-center justify-between bg-gradient-to-r from-blue-100 to-purple-100 rounded-lg shadow-lg p-8">
                    {/* Sol Bölüm: Başlık ve Açıklama */}
                    <div className="text-center lg:text-left">
                        <h2 className="text-2xl font-bold text-gray-800 mb-2">
                            Find Out About The Latest Courses With The{" "}
                            <span className="text-blue-600">Academy</span> Newsletter
                        </h2>
                    </div>

                    {/* Sağ Bölüm: Email Giriş ve Buton */}
                    <div className="mt-6 lg:mt-0">
                        <form className="flex flex-col sm:flex-row items-center bg-white p-2 rounded-full shadow-lg">
                            <input
                                type="email"
                                placeholder="Email Address..."
                                className="flex-1 px-4 py-2 rounded-l-full text-gray-600 focus:outline-none"
                            />
                            <button
                                type="submit"
                                className="bg-black text-white px-6 py-2 rounded-full font-semibold hover:bg-gray-800"
                            >
                                SUBMIT
                            </button>
                        </form>
                    </div>
                </div>
            </section>

        </section>
    );
}

export default InstructorsSection;
