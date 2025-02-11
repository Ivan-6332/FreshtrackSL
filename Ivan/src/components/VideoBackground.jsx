import React from 'react';

const VideoBackground = () => {
    return (
        <div className="fixed inset-0 -z-10">
            {/* Video Element */}
            <video
                autoPlay
                loop
                muted
                playsInline
                className="absolute w-full h-full object-cover"
            >
                <source src="/src/assets/background_video.mp4" type="video/mp4" />
                Your browser does not support the video tag.
            </video>

            {/* Overlay for better content visibility */}
            <div className="absolute inset-0 bg-gradient-to-b from-black/30 via-black/20 to-black/30 backdrop-blur-[1px]"></div>
        </div>
    );
};

export default VideoBackground;
