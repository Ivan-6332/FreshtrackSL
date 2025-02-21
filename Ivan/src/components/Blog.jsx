import React from 'react';

// Sample blog posts (you can replace these with real posts later)
const samplePosts = [
    {
        id: 1,
        title: "Coming Soon: Our First Blog Post",
        preview: "Stay tuned for exciting insights into our latest projects and industry trends.",
        imageUrl: "/src/assets/blog/placeholder1.jpg",
        date: "Coming Soon",
        readTime: "5 min read"
    },
    {
        id: 2,
        title: "Technology Insights",
        preview: "We'll be sharing our expertise on the latest technological advancements.",
        imageUrl: "/src/assets/blog/placeholder2.jpg",
        date: "Coming Soon",
        readTime: "4 min read"
    },
    {
        id: 3,
        title: "Industry Best Practices",
        preview: "Learn about the best practices we follow in our development process.",
        imageUrl: "/src/assets/blog/placeholder3.jpg",
        date: "Coming Soon",
        readTime: "6 min read"
    }
];

const Blog = () => {
    return (
        <section id="blog" className="py-20 bg-black min-h-screen">
            {/* Blog Header */}
            <div className="container mx-auto px-4 mb-16">
                <div className="text-center max-w-3xl mx-auto">
                    <h1 className="text-5xl font-bold text-white mb-6">Our Blog</h1>
                    <p className="text-lg text-gray-300 leading-relaxed mb-12">
                        Welcome to our blog space! Here we'll share insights, updates, and deep dives 
                        into technology, development practices, and industry trends. Stay tuned for 
                        regular updates from our team of experts.
                    </p>
                </div>
            </div>

            {/* Blog Grid */}
            <div className="container mx-auto px-4">
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    {samplePosts.map((post) => (
                        <div 
                            key={post.id} 
                            className="bg-zinc-900 rounded-lg overflow-hidden transform transition duration-300 hover:scale-105 hover:shadow-2xl"
                        >
                            <div className="h-48 overflow-hidden">
                                <img 
                                    src={post.imageUrl} 
                                    alt={post.title}
                                    className="w-full h-full object-cover"
                                />
                            </div>
                            <div className="p-6">
                                <div className="flex justify-between items-center mb-4">
                                    <span className="text-green-500">{post.date}</span>
                                    <span className="text-gray-400 text-sm">{post.readTime}</span>
                                </div>
                                <h3 className="text-xl font-semibold text-white mb-3">{post.title}</h3>
                                <p className="text-gray-400 mb-4">{post.preview}</p>
                                <button 
                                    className="text-green-500 font-medium hover:text-green-400 transition duration-300"
                                    onClick={() => alert('Blog post coming soon!')}
                                >
                                    Read More →
                                </button>
                            </div>
                        </div>
                    ))}
                </div>
            </div>

            {/* Newsletter Subscription */}
            <div className="container mx-auto px-4 mt-20">
                <div className="max-w-2xl mx-auto bg-zinc-900 rounded-lg p-8 text-center">
                    <h3 className="text-2xl font-semibold text-white mb-4">
                        Stay Updated
                    </h3>
                    <p className="text-gray-300 mb-6">
                        Subscribe to our newsletter to receive the latest blog posts and updates.
                    </p>
                    <div className="flex flex-col sm:flex-row gap-4 justify-center">
                        <input 
                            type="email" 
                            placeholder="Enter your email"
                            className="px-4 py-2 rounded-lg bg-zinc-800 text-white border border-zinc-700 focus:outline-none focus:border-green-500"
                        />
                        <button 
                            className="px-6 py-2 bg-green-500 text-white rounded-lg hover:bg-green-600 transition duration-300"
                            onClick={() => alert('Newsletter subscription coming soon!')}
                        >
                            Subscribe
                        </button>
                    </div>
                </div>
            </div>
        </section>
    );
};

export default Blog;
