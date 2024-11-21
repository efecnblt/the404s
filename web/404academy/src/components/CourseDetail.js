import React, { useEffect, useState } from "react";
import { collection, getDocs } from "firebase/firestore";
import { useParams } from "react-router-dom";
import { db } from "../firebase/firebaseConfig";

function CourseDetail() {
    const { authorId, courseId } = useParams();
    const [sections, setSections] = useState([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const fetchSections = async () => {
            try {
                const querySnapshot = await getDocs(
                    collection(db, `authors/${authorId}/courses/${courseId}/sections`)
                );
                const sectionsData = querySnapshot.docs.map((doc) => ({
                    id: doc.id,
                    ...doc.data(),
                }));
                setSections(sectionsData);
                setLoading(false);
            } catch (error) {
                console.error("Error fetching sections: ", error);
                setLoading(false);
            }
        };

        fetchSections();
    }, [authorId, courseId]);

    if (loading) {
        return <p className="text-center">Loading sections...</p>;
    }

    return (
        <section className="py-12 px-4">
            <h2 className="text-3xl font-bold text-center mb-6">Course Sections</h2>
            <div className="max-w-4xl mx-auto">
                {sections.map((section) => (
                    <div key={section.id} className="mb-4 p-4 bg-gray-100 rounded-lg">
                        <h3 className="text-lg font-semibold">{section.name}</h3>
                        <p>{section.description}</p>
                    </div>
                ))}
            </div>
        </section>
    );
}

export default CourseDetail;
