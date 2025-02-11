import React from 'react';
import Navbar from './components/Navbar';
import Hero from './components/Hero';
import WhatWeDo from './components/WhatWeDo';
import Team from './components/Team';
import Blog from './components/Blog';
import Contact from './components/Contact';
import VideoBackground from './components/VideoBackground';

const App = () => {
  return (
    <main className="relative min-h-screen overflow-x-hidden antialiased">
      {/* Video Background */}
      <VideoBackground />

      {/* Main Content */}
      <div className="relative">
        <Navbar />
        <div className="backdrop-blur-[1px]">
          <Hero />
          <WhatWeDo />
          <Team />
          <Blog />
          <Contact />
        </div>
      </div>
    </main>
  )
}

export default App;