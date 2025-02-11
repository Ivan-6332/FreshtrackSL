import React from 'react';

const teamMembers = [
    {
        name: "Ivan De Zoysa",
        role: "CEO & Founder",
        image: "/src/assets/team/Ivan.jpg",
        description: "Visionary leader with 15+ years of industry experience, driving innovation and growth."
    },
    {
        name: "Parama Herath",
        role: "Technical Director",
        image: "/team/member2.jpg",
        description: "Expert in cutting-edge technologies, leading our technical initiatives with precision."
    },
    {
        name: "Dinithi Viranda",
        role: "Creative Director",
        image: "/team/member3.jpg",
        description: "Award-winning creative professional bringing designs to life."
    },
    {
        name: "Gayantha Hathnagoda",
        role: "Marketing Head",
        image: "/team/member4.jpg",
        description: "Strategic marketing expert with a passion for brand storytelling."
    },
    {
        name: "Nethmee Mudannayaka",
        role: "Lead Developer",
        image: "/src/assets/team/Nethmee.jpg",
        description: "Full-stack developer extraordinaire, turning ideas into reality."
    },
    {
        name: "Dilshan Hirimuthugoda",
        role: "UX Designer",
        image: "/team/member6.jpg",
        description: "User experience specialist creating intuitive and engaging designs."
    }
];

const Team = () => {
    return (
        <section id="team" className="py-20 bg-black">
            {/* Hero Team Image */}
            <div className="relative h-[60vh] w-full mb-16">
                <img 
                    src="/team/team-hero.jpg" 
                    alt="Our Team" 
                    className="w-full h-full object-cover"
                />
                <div className="absolute inset-0 bg-black/50 flex items-center justify-center">
                    <h1 className="text-5xl font-bold text-white">Our Team</h1>
                </div>
            </div>

            {/* Team Description */}
            <div className="container mx-auto px-4 mb-20">
                <div className="max-w-3xl mx-auto text-center">
                    <p className="text-lg text-gray-300 leading-relaxed">
                        We are a passionate team of professionals dedicated to delivering excellence in every project. 
                        Our diverse backgrounds and expertise come together to create innovative solutions that drive 
                        success for our clients. Together, we're pushing the boundaries of what's possible.
                    </p>
                </div>
            </div>

            {/* Team Members Grid */}
            <div className="container mx-auto px-4">
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-12">
                    {teamMembers.map((member, index) => (
                        <div key={index} className="flex flex-col items-center group">
                            <div className="relative mb-6">
                                <div className="absolute inset-0 bg-green-500 rounded-full blur-lg group-hover:blur-xl transition-all duration-300 opacity-20 group-hover:opacity-30"></div>
                                <div className="relative w-40 h-40 overflow-hidden rounded-full border-4 border-zinc-800 group-hover:border-green-500 transition-all duration-300">
                                    <img 
                                        src={member.image} 
                                        alt={member.name}
                                        className="w-full h-full object-cover transform group-hover:scale-110 transition-all duration-300"
                                    />
                                </div>
                            </div>
                            <div className="text-center">
                                <h3 className="text-xl font-semibold text-white mb-1 group-hover:text-green-500 transition-colors duration-300">{member.name}</h3>
                                <p className="text-green-500 font-medium mb-2">{member.role}</p>
                                <p className="text-gray-400 text-sm max-w-xs mx-auto leading-relaxed">{member.description}</p>
                            </div>
                        </div>
                    ))}
                </div>
            </div>
        </section>
    );
};

export default Team;
