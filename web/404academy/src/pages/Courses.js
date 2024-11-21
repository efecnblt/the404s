import React, { useState } from "react";

function Courses() {
    const allCourses = [
        { id: "1", title: "Learn Figma", category: "Design" },
        { id: "2", title: "Python for Beginners", category: "Programming" },
        { id: "3", title: "Acoustic Guitar Basics", category: "Music" },
        { id: "4", title: "Mobile App Development", category: "Programming" },
        { id: "5", title: "Photography Basics", category: "Photography" },
    ];

    const [filter, setFilter] = useState("All");

    const filteredCourses =
        filter === "All"
            ? allCourses
            : allCourses.filter((course) => course.category === filter);

    return (
        <div className="py-12 px-4 bg-gray-50">
            <h1 className="text-4xl font-bold text-center mb-6">Courses</h1>
            <div className="text-center mb-8">
                <button
                    onClick={() => setFilter("All")}
                    className={`px-4 py-2 mx-2 rounded ${
                        filter === "All" ? "bg-purple-600 text-white" : "bg-gray-200"
                    }`}
                >
                    All
                </button>
                <button
                    onClick={() => setFilter("Design")}
                    className={`px-4 py-2 mx-2 rounded ${
                        filter === "Design" ? "bg-purple-600 text-white" : "bg-gray-200"
                    }`}
                >
                    Design
                </button>
                <button
                    onClick={() => setFilter("Programming")}
                    className={`px-4 py-2 mx-2 rounded ${
                        filter === "Programming" ? "bg-purple-600 text-white" : "bg-gray-200"
                    }`}
                >
                    Programming
                </button>
                <button
                    onClick={() => setFilter("Music")}
                    className={`px-4 py-2 mx-2 rounded ${
                        filter === "Music" ? "bg-purple-600 text-white" : "bg-gray-200"
                    }`}
                >
                    Music
                </button>
                <button
                    onClick={() => setFilter("Photography")}
                    className={`px-4 py-2 mx-2 rounded ${
                        filter === "Photography" ? "bg-purple-600 text-white" : "bg-gray-200"
                    }`}
                >
                    Photography
                </button>
            </div>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6 max-w-6xl mx-auto">
                {filteredCourses.map((course) => (
                    <div
                        key={course.id}
                        className="bg-white p-4 rounded-lg shadow hover:shadow-md"
                    >
                        <h3 className="text-lg font-semibold">{course.title}</h3>
                        <p className="text-sm text-gray-500">{course.category}</p>
                    </div>
                ))}
            </div>
        </div>
    );
}

export default Courses;
