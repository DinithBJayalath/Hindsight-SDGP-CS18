import { motion } from "framer-motion";
import { FiMail, FiPhone, FiMapPin } from "react-icons/fi";
import { fadeIn, staggerContainer } from "../utils/animations";

const contactInfo = [
  {
    icon: <FiMail className="w-6 h-6" />,
    title: "Email",
    content: "contact@hindsight.app",
    link: "mailto:contact@hindsight.app",
  },
  {
    icon: <FiPhone className="w-6 h-6" />,
    title: "Phone",
    content: "+94 770492904",
    link: "tel:+94770492904",
  },
  {
    icon: <FiMapPin className="w-6 h-6" />,
    title: "Location",
    content: "Colombo, Sri Lanka",
    link: "https://maps.google.com",
  },
];

const Contact = () => {
  return (
    <section
      id="contact"
      className="py-20 dark:bg-dark-bg relative overflow-hidden"
    >
      <div className="absolute inset-0 bg-gradient-radial from-primary/5 via-transparent to-transparent dark:from-dark-primary/5 animate-gradient-xy opacity-50" />
      <div className="container mx-auto px-6">
        <motion.div
          {...fadeIn}
          viewport={{ once: true }}
          transition={{ duration: 0.5 }}
          className="text-center mb-16"
        >
          <h2 className="text-3xl lg:text-4xl font-bold mb-4 dark:text-white">
            Get in Touch
          </h2>
          <p className="text-gray-600 dark:text-gray-300 max-w-2xl mx-auto">
            Have questions or feedback? We'd love to hear from you. Send us a
            message and we'll respond as soon as possible.
          </p>
        </motion.div>

        <div className="grid lg:grid-cols-3 gap-8 mb-16">
          {contactInfo.map((info, index) => (
            <motion.a
              key={info.title}
              href={info.link}
              target="_blank"
              rel="noopener noreferrer"
              variants={fadeIn}
              viewport={{ once: true }}
              transition={{ duration: 0.5, delay: index * 0.1 }}
              className="flex flex-col items-center p-6 bg-white dark:bg-dark-bg-lighter rounded-xl shadow-lg hover:shadow-xl transition-all hover:-translate-y-1"
            >
              <div className="text-primary dark:text-dark-primary mb-4">
                {info.icon}
              </div>
              <h3 className="text-xl font-semibold mb-2 dark:text-white">
                {info.title}
              </h3>
              <p className="text-gray-600 dark:text-gray-300 text-center">
                {info.content}
              </p>
            </motion.a>
          ))}
        </div>

        <motion.form
          variants={staggerContainer}
          initial="initial"
          whileInView="animate"
          viewport={{ once: true }}
          className="max-w-2xl mx-auto"
        >
          <motion.div
            variants={fadeIn}
            className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6"
          >
            <input
              type="text"
              placeholder="Your Name"
              className="px-4 py-3 bg-white dark:bg-dark-bg-lighter rounded-lg border border-gray-200 dark:border-gray-700 focus:outline-none focus:ring-2 focus:ring-primary dark:focus:ring-dark-primary"
            />
            <input
              type="email"
              placeholder="Your Email"
              className="px-4 py-3 bg-white dark:bg-dark-bg-lighter rounded-lg border border-gray-200 dark:border-gray-700 focus:outline-none focus:ring-2 focus:ring-primary dark:focus:ring-dark-primary"
            />
          </motion.div>
          <motion.div variants={fadeIn} className="mb-6">
            <textarea
              rows="5"
              placeholder="Your Message"
              className="w-full px-4 py-3 bg-white dark:bg-dark-bg-lighter rounded-lg border border-gray-200 dark:border-gray-700 focus:outline-none focus:ring-2 focus:ring-primary dark:focus:ring-dark-primary"
            />
          </motion.div>
          <motion.div variants={fadeIn} className="text-center">
            <button
              type="submit"
              className="btn-primary dark:bg-dark-primary dark:hover:bg-dark-primary-dark"
            >
              Send Message
            </button>
          </motion.div>
        </motion.form>
      </div>
    </section>
  );
};

export default Contact;
