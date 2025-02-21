import { useState, useEffect } from "react";
import { motion, AnimatePresence } from "framer-motion";

const CustomCursor = () => {
  const [mousePosition, setMousePosition] = useState({ x: 0, y: 0 });
  const [isVisible, setIsVisible] = useState(false);

  useEffect(() => {
    const updateMousePosition = (e) => {
      setMousePosition({ x: e.clientX, y: e.clientY });
    };

    const handleMouseEnter = () => setIsVisible(true);
    const handleMouseLeave = () => setIsVisible(false);

    window.addEventListener("mousemove", updateMousePosition);
    document.body.addEventListener("mouseenter", handleMouseEnter);
    document.body.addEventListener("mouseleave", handleMouseLeave);

    return () => {
      window.removeEventListener("mousemove", updateMousePosition);
      document.body.removeEventListener("mouseenter", handleMouseEnter);
      document.body.removeEventListener("mouseleave", handleMouseLeave);
    };
  }, []);

  return (
    <AnimatePresence>
      {isVisible && (
        <motion.div
          initial={{ scale: 0 }}
          animate={{
            scale: 1,
            x: mousePosition.x - 16,
            y: mousePosition.y - 16,
          }}
          exit={{ scale: 0 }}
          className="fixed w-8 h-8 pointer-events-none z-50 mix-blend-difference"
        >
          <div className="w-full h-full rounded-full bg-white opacity-50" />
        </motion.div>
      )}
    </AnimatePresence>
  );
};

export default CustomCursor;
