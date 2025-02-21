import { FiSun, FiMoon } from "react-icons/fi";
import { useApp } from "../context/AppContext";
import { motion } from "framer-motion";

const ThemeToggle = () => {
  const { isDarkMode, toggleDarkMode } = useApp();

  return (
    <motion.button
      onClick={toggleDarkMode}
      className="w-10 h-10 rounded-lg bg-gray-100 dark:bg-gray-800 flex items-center justify-center transition-colors duration-200"
      whileTap={{ scale: 0.95 }}
      title={isDarkMode ? "Switch to light mode" : "Switch to dark mode"}
    >
      {isDarkMode ? (
        <FiSun className="w-5 h-5 text-gray-600 dark:text-gray-300" />
      ) : (
        <FiMoon className="w-5 h-5 text-gray-600 dark:text-gray-300" />
      )}
    </motion.button>
  );
};

export default ThemeToggle;
