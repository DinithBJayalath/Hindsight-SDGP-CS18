import { AnimatePresence } from "framer-motion";
import { useScroll } from "./hooks/useScroll";
import { useApp } from "./context/AppContext";
import Navbar from "./components/Navbar";
import Hero from "./components/Hero";
import Features from "./components/Features";
import Team from "./components/Team";
import Testimonials from "./components/Testimonials";
import FAQ from "./components/FAQ";
import CTA from "./components/CTA";
import Contact from "./components/Contact";
import Footer from "./components/Footer";
import ScrollToTop from "./components/ScrollToTop";
import LoadingScreen from "./components/LoadingScreen";
import AppShowcase from "./components/AppShowcase";
import emailjs from "@emailjs/browser";

// Replace with your actual public key
emailjs.init("yBE9NtQo_BddvpYha");

function App() {
  const { isLoading, isDarkMode } = useApp();
  const { scrolled } = useScroll(50);

  return (
    <>
      <AnimatePresence mode="wait">
        {isLoading && <LoadingScreen />}
      </AnimatePresence>
      <div className={`min-h-screen ${isDarkMode ? "dark" : ""}`}>
        <div className="app-background">
          <Navbar scrolled={scrolled} />
          <main>
            <Hero />
            <Features />
            <AppShowcase />
            <Team />
            <Testimonials />
            <FAQ />
            <Contact />
            <CTA />
          </main>
          <Footer />
          <ScrollToTop />
        </div>
      </div>
    </>
  );
}

export default App;
