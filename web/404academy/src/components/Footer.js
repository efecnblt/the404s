import React from "react";

function Footer() {
    return (
        <footer className="bg-gray-800 text-white py-8">
            <div className="container mx-auto text-center">
                <h3 className="text-lg font-bold">ACADEMY</h3>
                <p className="text-sm mt-2">Learn and grow with the best online courses.</p>
                <div className="flex justify-center mt-4 space-x-6">
                    <a href="#" className="hover:text-purple-500">Privacy Policy</a>
                    <a href="#" className="hover:text-purple-500">Terms & Conditions</a>
                    <a href="#" className="hover:text-purple-500">Contact Us</a>
                </div>
                <p className="mt-6 text-xs">&copy; 2024 Academy. All rights reserved.</p>
            </div>
        </footer>
    );
}

export default Footer;
