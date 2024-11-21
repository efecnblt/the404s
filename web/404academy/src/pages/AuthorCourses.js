import React from "react";
import CoursesList from "../components/CoursesList";

function AuthorCourses({ authorId }) {
    return (
        <div>
            <h1>Courses by Author</h1>
            <CoursesList authorId={authorId} />
        </div>
    );
}

export default AuthorCourses;
