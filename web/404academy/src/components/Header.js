import React from "react";
import { Link } from "react-router-dom";

function Header() {
    return (
        <header className="flex justify-between items-center p-4 bg-gray-100 shadow-md">
            <div className="text-2xl font-bold text-purple-600">
                <Link to="/">404 ACADEMY</Link>
            </div>
            <nav className="flex space-x-6">
                <Link to="/" className="text-gray-700 hover:text-purple-600">Home</Link>
                <Link to="/courses" className="text-gray-700 hover:text-purple-600">Courses</Link>
                <Link to="/contact" className="text-gray-700 hover:text-purple-600">Contact</Link>
            </nav>
        </header>
    );
}

export default Header;
