import React from "react";
import CourseDetail from "../components/CourseDetail";

function CourseDetailPage({ authorId, courseId }) {
    return (
        <div>
            <h1>Course Details</h1>
            <CourseDetail authorId={authorId} courseId={courseId} />
        </div>
    );
}

export default CourseDetailPage;
