import { motion, AnimatePresence } from "framer-motion";
import { Link } from "react-scroll";
import { FiDownload, FiMenu, FiX } from "react-icons/fi";
import ThemeToggle from "./ThemeToggle";
import { fadeIn } from "../utils/animations";
import { useState } from "react";

const navItems = [
  { name: "Home", to: "home" },
  { name: "Features", to: "features" },
  { name: "Team", to: "team" },
  { name: "Testimonials", to: "testimonials" },
  { name: "FAQ", to: "faq" },
  { name: "Contact", to: "contact" },
];

const Navbar = ({ scrolled }) => {
  const [isMenuOpen, setIsMenuOpen] = useState(false);

  return (
    <nav
      className={`fixed top-0 left-0 right-0 z-50 transition-all duration-500 ${
        scrolled
          ? "bg-white/80 dark:bg-gray-900/80 backdrop-blur-lg shadow-lg"
          : "bg-transparent"
      }`}
    >
      <div className="container">
        <div className="flex items-center justify-between h-20">
          {/* Logo */}
          <motion.div
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            className="relative"
          >
            <Link to="home" className="cursor-pointer">
              <h1 className="text-2xl font-bold">
                <span className="gradient-text">Hind</span>
                <span className="text-gray-900 dark:text-white">Sight</span>
              </h1>
              <div className="absolute -bottom-1 left-0 w-full h-[2px] bg-gradient-to-r from-primary to-secondary dark:from-dark-primary dark:to-dark-secondary transform scale-x-0 group-hover:scale-x-100 transition-transform duration-300" />
            </Link>
          </motion.div>

          {/* Desktop Menu */}
          <div className="hidden lg:flex items-center space-x-1">
            {navItems.map((item, index) => (
              <motion.div
                key={item.name}
                initial={{ opacity: 0, y: -10 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: index * 0.1 }}
              >
                <Link
                  to={item.to}
                  smooth={true}
                  duration={500}
                  className="relative px-4 py-2 text-gray-700 dark:text-gray-300 hover:text-primary dark:hover:text-dark-primary transition-colors group"
                >
                  {item.name}
                  <div className="absolute bottom-0 left-0 w-full h-0.5 bg-primary dark:bg-dark-primary transform scale-x-0 group-hover:scale-x-100 transition-transform duration-300" />
                </Link>
              </motion.div>
            ))}
          </div>

          {/* Actions */}
          <div className="flex items-center space-x-4">
            <ThemeToggle />
            <motion.button
              initial={{ opacity: 0, x: 20 }}
              animate={{ opacity: 1, x: 0 }}
              className="hidden md:flex btn-modern btn-modern-group items-center gap-2 px-6 py-2.5 rounded-full text-white"
            >
              <FiDownload className="w-4 h-4" />
              <span>Download</span>
            </motion.button>

            {/* Mobile Menu Button */}
            <button
              onClick={() => setIsMenuOpen(!isMenuOpen)}
              className="lg:hidden p-2 hover:bg-gray-100 dark:hover:bg-gray-800 rounded-full transition-colors"
            >
              {isMenuOpen ? (
                <FiX className="w-6 h-6" />
              ) : (
                <FiMenu className="w-6 h-6" />
              )}
            </button>
          </div>
        </div>

        {/* Mobile Menu */}
        <AnimatePresence>
          {isMenuOpen && (
            <motion.div
              initial={{ opacity: 0, height: 0 }}
              animate={{ opacity: 1, height: "auto" }}
              exit={{ opacity: 0, height: 0 }}
              transition={{ duration: 0.3 }}
              className="lg:hidden border-t border-gray-200 dark:border-gray-700"
            >
              <div className="py-4 space-y-2">
                {navItems.map((item) => (
                  <Link
                    key={item.name}
                    to={item.to}
                    smooth={true}
                    duration={500}
                    className="block px-6 py-2 text-gray-700 dark:text-gray-300 hover:text-primary dark:hover:text-dark-primary hover:bg-gray-50 dark:hover:bg-gray-800/50 transition-colors"
                    onClick={() => setIsMenuOpen(false)}
                  >
                    {item.name}
                  </Link>
                ))}
              </div>
            </motion.div>
          )}
        </AnimatePresence>
      </div>
    </nav>
  );
};

export default Navbar;
