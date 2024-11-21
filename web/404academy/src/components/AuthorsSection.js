import React, { useEffect, useState } from "react";
import { collection, getDocs } from "firebase/firestore";
import { db } from "../firebase/firebaseConfig";
import { Link } from "react-router-dom";

function AuthorsSection() {
    const [authors, setAuthors] = useState([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const fetchAuthors = async () => {
            try {
                const querySnapshot = await getDocs(collection(db, "authors"));
                const authorsData = querySnapshot.docs.map((doc) => ({
                    id: doc.id,
                    ...doc.data(),
                }));
                setAuthors(authorsData);
                setLoading(false);
            } catch (error) {
                console.error("Error fetching authors: ", error);
                setLoading(false);
            }
        };

        fetchAuthors();
    }, []);

    if (loading) {
        return <p className="text-center">Loading authors...</p>;
    }

    return (
        <section className="py-12 bg-white">
            <h2 className="text-3xl font-bold text-center mb-6">Authors</h2>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6 max-w-6xl mx-auto">
                {authors.map((author) => (
                    <div key={author.id} className="bg-gray-100 p-4 rounded-lg shadow hover:shadow-md text-center">
                        <img
                            src={author.image_url}
                            alt={author.name}
                            className="w-24 h-24 rounded-full mx-auto mb-4"
                        />
                        <h3 className="text-lg font-semibold">{author.name}</h3>
                        <p>{author.department}</p>
                        <p className="text-sm text-gray-500">
                            Rating: {author.rating} | Students: {author.studentCount}
                        </p>
                        <Link
                            to={`/authors/${author.id}/courses`}
                            className="mt-4 inline-block bg-purple-600 text-white px-4 py-2 rounded hover:bg-purple-700"
                        >
                            View Courses
                        </Link>
                    </div>
                ))}
            </div>
        </section>
    );
}

export default AuthorsSection;
