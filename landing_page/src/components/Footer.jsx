import { Link } from "react-scroll";
import {
  FiLinkedin,
  FiTwitter,
  FiInstagram,
  FiGithub,
  FiMail,
} from "react-icons/fi";
import { motion } from "framer-motion";
import { fadeIn, staggerContainer } from "../utils/animations";

const Footer = () => {
  const currentYear = new Date().getFullYear();

  const footerLinks = [
    { name: "Home", href: "home" },
    { name: "Features", href: "features" },
    { name: "Team", href: "team" },
    { name: "FAQ", href: "faq" },
    { name: "Contact", href: "contact" },
  ];

  const socialLinks = [
    {
      name: "GitHub",
      href: "https://github.com/your-github",
      icon: FiGithub,
    },
    {
      name: "LinkedIn",
      href: "https://linkedin.com/in/your-linkedin",
      icon: FiLinkedin,
    },
    {
      name: "Twitter",
      href: "https://twitter.com/your-twitter",
      icon: FiTwitter,
    },
    {
      name: "Email",
      href: "mailto:your@email.com",
      icon: FiMail,
    },
  ];

  return (
    <footer className="relative bg-white dark:bg-gray-900 pt-20 pb-6 overflow-hidden">
      <div className="absolute inset-0 bg-gradient-to-b from-transparent via-primary/5 to-transparent dark:via-dark-primary/5" />

      <div className="container relative z-10">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-12 lg:gap-8 mb-12">
          {/* Brand */}
          <div className="space-y-4">
            <h3 className="text-2xl font-bold">
              <span className="gradient-text">Hind</span>
              <span className="text-gray-900 dark:text-white">Sight</span>
            </h3>
            <p className="text-gray-600 dark:text-gray-400 max-w-xs">
              Your personal mental wellness companion. Track, reflect, and grow
              with HindSight.
            </p>
          </div>

          {/* Quick Links */}
          <div>
            <h4 className="text-lg font-semibold mb-4 text-gray-900 dark:text-white">
              Quick Links
            </h4>
            <ul className="space-y-2">
              {footerLinks.map((link) => (
                <li key={link.name}>
                  <Link
                    to={link.href}
                    smooth={true}
                    duration={500}
                    className="text-gray-600 dark:text-gray-400 hover:text-primary dark:hover:text-dark-primary transition-colors cursor-pointer"
                  >
                    {link.name}
                  </Link>
                </li>
              ))}
            </ul>
          </div>

          {/* Contact */}
          <div>
            <h4 className="text-lg font-semibold mb-4 text-gray-900 dark:text-white">
              Contact
            </h4>
            <ul className="space-y-2 text-gray-600 dark:text-gray-400">
              <li>Colombo, Sri Lanka</li>
              <li>+94 77 123 4567</li>
              <li>support@hindsight.com</li>
            </ul>
          </div>

          {/* Social Links */}
          <div>
            <h4 className="text-lg font-semibold mb-4 text-gray-900 dark:text-white">
              Follow Us
            </h4>
            <div className="flex space-x-4">
              {socialLinks.map((link) => {
                const Icon = link.icon;
                return (
                  <a
                    key={link.name}
                    href={link.href}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="p-2 bg-gray-50 dark:bg-gray-800 rounded-lg hover:bg-primary/10 dark:hover:bg-dark-primary/10 text-gray-600 dark:text-gray-400 hover:text-primary dark:hover:text-dark-primary transition-colors flex items-center justify-center"
                  >
                    <Icon className="w-5 h-5" />
                  </a>
                );
              })}
            </div>
          </div>
        </div>

        {/* Bottom Bar */}
        <div className="border-t border-gray-200 dark:border-gray-800 pt-6 mt-12">
          <div className="flex flex-col md:flex-row justify-between items-center space-y-4 md:space-y-0">
            <p className="text-gray-600 dark:text-gray-400 text-sm">
              © {currentYear} HindSight. All rights reserved.
            </p>
            <div className="flex space-x-6 text-sm text-gray-600 dark:text-gray-400">
              <a
                href="#"
                className="hover:text-primary dark:hover:text-dark-primary transition-colors"
              >
                Privacy Policy
              </a>
              <a
                href="#"
                className="hover:text-primary dark:hover:text-dark-primary transition-colors"
              >
                Terms of Service
              </a>
            </div>
          </div>
        </div>
      </div>
    </footer>
  );
};

export default Footer;
