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

function App() {
  const { isLoading, isDarkMode } = useApp();
  const { scrolled } = useScroll(50);

  return (
    <>
      <AnimatePresence mode="wait">
        {isLoading && <LoadingScreen />}
      </AnimatePresence>
      <div className={`min-h-screen ${isDarkMode ? "dark" : ""}`}>
        <div className="bg-gradient-to-b from-white to-secondary/20 dark:from-gray-900 dark:to-dark-secondary/20">
          <Navbar scrolled={scrolled} />
          <main>
            <Hero />
            <Features />
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
