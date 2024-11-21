import React from "react";

function HeroSection() {
    return (
        <section className="text-center py-16 bg-purple-50">
            <h1 className="text-5xl font-extrabold mb-4 text-purple-700">Hello Friends</h1>
            <p className="text-lg text-gray-600">
                I am Sofia, and we want to start a web design course together. Do you like it too? 😊
            </p>
            <button className="mt-6 px-6 py-3 bg-purple-600 text-white rounded-lg text-lg shadow hover:bg-purple-700">
                Start Course Now
            </button>
        </section>
    );
}

export default HeroSection;
