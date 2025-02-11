import React, { useState } from 'react';

const Contact = () => {
    const [rating, setRating] = useState(0);
    const [hover, setHover] = useState(0);
    const [reviewText, setReviewText] = useState('');
    const [feedbackType, setFeedbackType] = useState('general');
    
    const handleSubmitReview = (e) => {
        e.preventDefault();
        // Here you would typically send the review to your backend
        alert('Thank you for your review!');
        setRating(0);
        setReviewText('');
    };

    const handleSubmitFeedback = (e) => {
        e.preventDefault();
        // Here you would typically send the feedback to your backend
        alert('Thank you for your feedback!');
        e.target.reset();
    };

    return (
        <section id="contact" className="py-20 bg-black min-h-screen">
            {/* Header */}
            <div className="container mx-auto px-4 mb-16">
                <div className="text-center max-w-3xl mx-auto">
                    <h1 className="text-5xl font-bold text-white mb-6">Contact Us</h1>
                    <p className="text-lg text-gray-300 leading-relaxed">
                        We'd love to hear from you! Whether you have a question, feedback, or want to leave a review,
                        we're here to help.
                    </p>
                </div>
            </div>

            <div className="container mx-auto px-4">
                <div className="grid grid-cols-1 lg:grid-cols-2 gap-12">
                    {/* Contact Form */}
                    <div className="bg-zinc-900 p-8 rounded-lg">
                        <h2 className="text-2xl font-semibold text-white mb-6">Send us a message</h2>
                        <form onSubmit={handleSubmitFeedback} className="space-y-6">
                            <div>
                                <label className="block text-gray-300 mb-2">Feedback Type</label>
                                <select 
                                    className="w-full px-4 py-2 rounded-lg bg-zinc-800 text-white border border-zinc-700 focus:outline-none focus:border-green-500"
                                    value={feedbackType}
                                    onChange={(e) => setFeedbackType(e.target.value)}
                                >
                                    <option value="general">General Inquiry</option>
                                    <option value="support">Technical Support</option>
                                    <option value="feature">Feature Request</option>
                                    <option value="bug">Bug Report</option>
                                </select>
                            </div>
                            <div>
                                <label className="block text-gray-300 mb-2">Name</label>
                                <input 
                                    type="text" 
                                    required
                                    className="w-full px-4 py-2 rounded-lg bg-zinc-800 text-white border border-zinc-700 focus:outline-none focus:border-green-500"
                                    placeholder="Your name"
                                />
                            </div>
                            <div>
                                <label className="block text-gray-300 mb-2">Email</label>
                                <input 
                                    type="email" 
                                    required
                                    className="w-full px-4 py-2 rounded-lg bg-zinc-800 text-white border border-zinc-700 focus:outline-none focus:border-green-500"
                                    placeholder="your@email.com"
                                />
                            </div>
                            <div>
                                <label className="block text-gray-300 mb-2">Message</label>
                                <textarea 
                                    required
                                    className="w-full px-4 py-2 rounded-lg bg-zinc-800 text-white border border-zinc-700 focus:outline-none focus:border-green-500 h-32"
                                    placeholder="Your message..."
                                ></textarea>
                            </div>
                            <button 
                                type="submit"
                                className="w-full py-3 bg-green-500 text-white rounded-lg hover:bg-green-600 transition duration-300"
                            >
                                Send Message
                            </button>
                        </form>
                    </div>

                    {/* Review System */}
                    <div className="bg-zinc-900 p-8 rounded-lg">
                        <h2 className="text-2xl font-semibold text-white mb-6">Leave a Review</h2>
                        <form onSubmit={handleSubmitReview} className="space-y-6">
                            <div>
                                <label className="block text-gray-300 mb-4">Rating</label>
                                <div className="flex gap-2 mb-4">
                                    {[...Array(5)].map((_, index) => {
                                        const ratingValue = index + 1;
                                        return (
                                            <label key={index} className="cursor-pointer">
                                                <input 
                                                    type="radio" 
                                                    name="rating" 
                                                    className="hidden"
                                                    value={ratingValue}
                                                    onClick={() => setRating(ratingValue)}
                                                />
                                                <span 
                                                    className={`text-3xl transition duration-200 ${
                                                        ratingValue <= (hover || rating) 
                                                            ? 'text-green-500' 
                                                            : 'text-gray-600'
                                                    }`}
                                                    onMouseEnter={() => setHover(ratingValue)}
                                                    onMouseLeave={() => setHover(0)}
                                                >
                                                    ★
                                                </span>
                                            </label>
                                        );
                                    })}
                                </div>
                            </div>
                            <div>
                                <label className="block text-gray-300 mb-2">Your Review</label>
                                <textarea 
                                    value={reviewText}
                                    onChange={(e) => setReviewText(e.target.value)}
                                    required
                                    className="w-full px-4 py-2 rounded-lg bg-zinc-800 text-white border border-zinc-700 focus:outline-none focus:border-green-500 h-32"
                                    placeholder="Share your experience..."
                                ></textarea>
                            </div>
                            <button 
                                type="submit"
                                className="w-full py-3 bg-green-500 text-white rounded-lg hover:bg-green-600 transition duration-300"
                            >
                                Submit Review
                            </button>
                        </form>
                    </div>
                </div>

                {/* Contact Information */}
                <div className="mt-16 grid grid-cols-1 md:grid-cols-3 gap-8">
                    <div className="bg-zinc-900 p-6 rounded-lg text-center">
                        <div className="text-green-500 text-2xl mb-4">📍</div>
                        <h3 className="text-white font-semibold mb-2">Address</h3>
                        <p className="text-gray-300">123 Business Street, Suite 100<br />City, State 12345</p>
                    </div>
                    <div className="bg-zinc-900 p-6 rounded-lg text-center">
                        <div className="text-green-500 text-2xl mb-4">📧</div>
                        <h3 className="text-white font-semibold mb-2">Email</h3>
                        <p className="text-gray-300">contact@yourcompany.com<br />support@yourcompany.com</p>
                    </div>
                    <div className="bg-zinc-900 p-6 rounded-lg text-center">
                        <div className="text-green-500 text-2xl mb-4">📱</div>
                        <h3 className="text-white font-semibold mb-2">Phone</h3>
                        <p className="text-gray-300">+1 (555) 123-4567<br />+1 (555) 987-6543</p>
                    </div>
                </div>
            </div>
        </section>
    );
};

export default Contact;
