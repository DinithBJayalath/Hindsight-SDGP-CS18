import { motion } from "framer-motion";
import { useApp } from "../context/AppContext";

const LoadingScreen = () => {
  const { isDarkMode } = useApp();

  return (
    <motion.div
      initial={{ opacity: 1 }}
      exit={{ opacity: 0 }}
      transition={{ duration: 0.5 }}
      className={`fixed inset-0 ${
        isDarkMode ? "bg-gray-900" : "bg-white"
      } z-100 flex items-center justify-center`}
    >
      <motion.div
        animate={{
          scale: [1, 1.2, 1],
          opacity: [1, 0.8, 1],
        }}
        transition={{
          duration: 1.5,
          repeat: Infinity,
          ease: "easeInOut",
        }}
        className={`text-4xl font-bold ${
          isDarkMode ? "text-dark-primary" : "text-primary"
        }`}
      >
        HindSight
      </motion.div>
    </motion.div>
  );
};

export default LoadingScreen;
