import React from "react";

function Contact() {
    return (
        <div className="py-12 bg-white">
            <h1 className="text-4xl font-bold text-center mb-6">Contact Us</h1>
            <p className="text-center text-gray-600">
                Have questions? Get in touch with us using the form below.
            </p>
            <form className="max-w-lg mx-auto mt-6">
                <div className="mb-4">
                    <label className="block text-sm font-medium text-gray-700">Name</label>
                    <input
                        type="text"
                        className="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:border-purple-500 focus:ring-purple-500"
                        placeholder="Your Name"
                    />
                </div>
                <div className="mb-4">
                    <label className="block text-sm font-medium text-gray-700">Email</label>
                    <input
                        type="email"
                        className="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:border-purple-500 focus:ring-purple-500"
                        placeholder="Your Email"
                    />
                </div>
                <div className="mb-4">
                    <label className="block text-sm font-medium text-gray-700">Message</label>
                    <textarea
                        className="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:border-purple-500 focus:ring-purple-500"
                        placeholder="Your Message"
                        rows="4"
                    ></textarea>
                </div>
                <button
                    type="submit"
                    className="w-full px-4 py-2 bg-purple-600 text-white rounded-md hover:bg-purple-700"
                >
                    Send Message
                </button>
            </form>
        </div>
    );
}

export default Contact;
