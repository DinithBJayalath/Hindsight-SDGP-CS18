import { motion } from "framer-motion";
import { FiSun, FiMoon } from "react-icons/fi";
import { useApp } from "../context/AppContext";

const ThemeToggle = () => {
  const { isDarkMode, toggleDarkMode } = useApp();

  return (
    <motion.button
      whileHover={{ scale: 1.1 }}
      whileTap={{ scale: 0.9 }}
      onClick={toggleDarkMode}
      className="p-2 rounded-full hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors"
      aria-label={isDarkMode ? "Switch to light mode" : "Switch to dark mode"}
    >
      {isDarkMode ? (
        <FiSun className="w-5 h-5 text-yellow-400" />
      ) : (
        <FiMoon className="w-5 h-5 text-gray-600" />
      )}
    </motion.button>
  );
};

export default ThemeToggle;
