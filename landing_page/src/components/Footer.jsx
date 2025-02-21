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

  const footerLinks = {
    Product: [
      { name: "Features", to: "features" },
      { name: "Testimonials", to: "testimonials" },
      { name: "FAQ", to: "faq" },
      { name: "Contact", to: "contact" },
    ],
    Company: [
      { name: "About Us", to: "team" },
      { name: "Careers", href: "#" },
      { name: "Privacy Policy", href: "#" },
      { name: "Terms of Service", href: "#" },
    ],
    Contact: [
      { name: "Support", href: "mailto:support@hindsight.app" },
      { name: "Sales", href: "mailto:sales@hindsight.app" },
      { name: "Press", href: "mailto:press@hindsight.app" },
    ],
  };

  const socialLinks = [
    { icon: <FiLinkedin className="w-5 h-5" />, href: "#", label: "LinkedIn" },
    { icon: <FiTwitter className="w-5 h-5" />, href: "#", label: "Twitter" },
    {
      icon: <FiInstagram className="w-5 h-5" />,
      href: "#",
      label: "Instagram",
    },
    { icon: <FiGithub className="w-5 h-5" />, href: "#", label: "GitHub" },
    {
      icon: <FiMail className="w-5 h-5" />,
      href: "mailto:contact@hindsight.app",
      label: "Email",
    },
  ];

  return (
    <footer className="relative overflow-hidden pt-20 pb-10 mt-20 bg-white/80 dark:bg-gray-900/80">
      <div className="container mx-auto px-6">
        <motion.div
          variants={staggerContainer}
          initial="initial"
          whileInView="animate"
          viewport={{ once: true }}
          className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-8 lg:gap-12 mb-16 relative"
        >
          <motion.div
            variants={fadeIn}
            className="col-span-1 sm:col-span-2 lg:col-span-1"
          >
            <div className="text-2xl font-bold text-primary dark:text-dark-primary mb-4">
              HindSight
            </div>
            <p className="text-gray-600 dark:text-gray-300 mb-6">
              Empowering mental well-being through technology and
              self-reflection.
            </p>
            <div className="flex space-x-4">
              {socialLinks.map((link) => (
                <a
                  key={link.label}
                  href={link.href}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="text-gray-400 hover:text-primary dark:hover:text-dark-primary transition-colors p-2 hover:bg-primary/10 dark:hover:bg-dark-primary/10 rounded-full"
                  aria-label={link.label}
                >
                  {link.icon}
                </a>
              ))}
            </div>
          </motion.div>

          {Object.entries(footerLinks).map(([title, links]) => (
            <motion.div key={title} variants={fadeIn} className="col-span-1">
              <h3 className="font-semibold mb-4 dark:text-white">{title}</h3>
              <ul className="space-y-2">
                {links.map((link) => (
                  <li key={link.name}>
                    {link.to ? (
                      <Link
                        to={link.to}
                        smooth={true}
                        duration={500}
                        className="text-gray-600 dark:text-gray-300 hover:text-primary dark:hover:text-dark-primary transition-colors cursor-pointer block py-1"
                      >
                        {link.name}
                      </Link>
                    ) : (
                      <a
                        href={link.href}
                        className="text-gray-600 dark:text-gray-300 hover:text-primary dark:hover:text-dark-primary transition-colors block py-1"
                      >
                        {link.name}
                      </a>
                    )}
                  </li>
                ))}
              </ul>
            </motion.div>
          ))}
        </motion.div>

        <motion.div
          variants={fadeIn}
          initial="initial"
          whileInView="animate"
          viewport={{ once: true }}
          className="border-t border-gray-200 dark:border-gray-700 pt-8"
        >
          <p className="text-center text-gray-600 dark:text-gray-400">
            © {currentYear} HindSight. All rights reserved.
          </p>
        </motion.div>
      </div>
    </footer>
  );
};

export default Footer;
