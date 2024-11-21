import React from "react";

function Newsletter() {
    return (
        <section className="py-12 bg-purple-50 text-center">
            <h2 className="text-3xl font-bold mb-4">Subscribe to Our Newsletter</h2>
            <p className="text-gray-600 mb-6">Get the latest updates and offers right in your inbox.</p>
            <form className="max-w-md mx-auto">
                <input
                    type="email"
                    className="w-full px-4 py-2 border-gray-300 rounded-lg focus:ring-purple-500 focus:border-purple-500"
                    placeholder="Enter your email"
                />
                <button
                    type="submit"
                    className="w-full mt-4 px-4 py-2 bg-purple-600 text-white rounded-lg hover:bg-purple-700"
                >
                    Subscribe
                </button>
            </form>
        </section>
    );
}

export default Newsletter;
