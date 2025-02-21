import { motion } from "framer-motion";
import { Link } from "react-scroll";
import { FiDownload } from "react-icons/fi";
import ThemeToggle from "./ThemeToggle";
import { fadeIn } from "../utils/animations";

const navItems = [
  { name: "Home", to: "home" },
  { name: "Features", to: "features" },
  { name: "Team", to: "team" },
  { name: "Testimonials", to: "testimonials" },
  { name: "FAQ", to: "faq" },
  { name: "Contact", to: "contact" },
];

const Navbar = ({ scrolled }) => {
  return (
    <motion.nav
      {...fadeIn}
      transition={{ duration: 0.3 }}
      className={`fixed w-full z-50 transition-all duration-300 ${
        scrolled
          ? "bg-white/80 dark:bg-gray-900/80 backdrop-blur-md shadow-lg"
          : "bg-transparent"
      }`}
    >
      <div className="container mx-auto px-6 py-4">
        <div className="flex items-center justify-between">
          <div className="text-2xl font-bold text-primary dark:text-dark-primary">
            HindSight
          </div>

          <div className="hidden md:flex items-center space-x-8">
            {navItems.map((item) => (
              <Link
                key={item.name}
                to={item.to}
                smooth={true}
                duration={500}
                className="cursor-pointer hover:text-primary dark:hover:text-dark-primary transition-colors dark:text-gray-300"
              >
                {item.name}
              </Link>
            ))}
          </div>

          <div className="flex items-center space-x-2 md:space-x-4">
            <ThemeToggle />
            <button className="hidden md:flex btn-primary items-center space-x-2">
              <FiDownload />
              <span>Download App</span>
            </button>
          </div>
        </div>
      </div>
    </motion.nav>
  );
};

export default Navbar;
