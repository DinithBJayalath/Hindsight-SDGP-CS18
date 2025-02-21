import { motion } from "framer-motion";
import { FiMail, FiPhone, FiMapPin } from "react-icons/fi";
import { fadeInUp, stagger } from "../utils/animations";

const contactInfo = [
  {
    icon: <FiMail className="w-5 h-5" />,
    title: "Email",
    details: "support@hindsight.com",
    link: "mailto:support@hindsight.com",
  },
  {
    icon: <FiPhone className="w-5 h-5" />,
    title: "Phone",
    details: "+94 77 123 4567",
    link: "tel:+94771234567",
  },
  {
    icon: <FiMapPin className="w-5 h-5" />,
    title: "Location",
    details: "Colombo, Sri Lanka",
    link: "https://goo.gl/maps/...",
  },
];

const Contact = () => {
  const handleSubmit = (e) => {
    e.preventDefault();
    // Handle form submission
  };

  return (
    <section
      id="contact"
      className="section-bg section-bg-alternate section-padding"
    >
      <div className="section-gradient" />
      <div className="container">
        <motion.div
          {...fadeInUp}
          className="content-narrow text-center section-spacing"
        >
          <h2 className="text-3xl lg:text-4xl font-bold mb-4 dark:text-white">
            Get in Touch
          </h2>
          <p className="text-gray-600 dark:text-gray-300">
            Have questions? We'd love to hear from you. Send us a message and
            we'll respond as soon as possible.
          </p>
        </motion.div>

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8 lg:gap-12 content-wide">
          {/* Contact Form */}
          <motion.div
            variants={stagger}
            initial="initial"
            whileInView="animate"
            viewport={{ once: true }}
            className="relative z-10"
          >
            <div className="glass-card rounded-2xl p-6 sm:p-8 relative overflow-hidden">
              {/* Add decorative gradient */}
              <div className="absolute inset-0 bg-gradient-to-br from-primary/5 to-transparent dark:from-dark-primary/5" />

              <form onSubmit={handleSubmit} className="relative z-10 space-y-6">
                <div>
                  <label
                    htmlFor="name"
                    className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2"
                  >
                    Name
                  </label>
                  <input
                    type="text"
                    id="name"
                    name="name"
                    placeholder="Enter your name"
                    className="w-full px-4 py-3 rounded-xl bg-white/50 dark:bg-gray-800/50 
                               border border-white/20 dark:border-gray-700/30
                               text-gray-900 dark:text-white 
                               placeholder-gray-500 dark:placeholder-gray-400
                               focus:ring-2 focus:ring-primary/20 dark:focus:ring-dark-primary/20
                               transition-all duration-300"
                    required
                  />
                </div>
                <div>
                  <label
                    htmlFor="email"
                    className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2"
                  >
                    Email
                  </label>
                  <input
                    type="email"
                    id="email"
                    name="email"
                    placeholder="Enter your email"
                    className="w-full px-4 py-3 rounded-xl bg-white/50 dark:bg-gray-800/50 
                               border border-white/20 dark:border-gray-700/30
                               text-gray-900 dark:text-white 
                               placeholder-gray-500 dark:placeholder-gray-400
                               focus:ring-2 focus:ring-primary/20 dark:focus:ring-dark-primary/20
                               transition-all duration-300"
                    required
                  />
                </div>
                <div>
                  <label
                    htmlFor="message"
                    className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2"
                  >
                    Message
                  </label>
                  <textarea
                    id="message"
                    name="message"
                    rows={4}
                    placeholder="Enter your message"
                    className="w-full px-4 py-3 rounded-xl bg-white/50 dark:bg-gray-800/50 
                               border border-white/20 dark:border-gray-700/30
                               text-gray-900 dark:text-white 
                               placeholder-gray-500 dark:placeholder-gray-400
                               focus:ring-2 focus:ring-primary/20 dark:focus:ring-dark-primary/20
                               transition-all duration-300 resize-none"
                    required
                  ></textarea>
                </div>
                <button
                  type="submit"
                  className="w-full btn-primary dark:bg-dark-primary dark:hover:bg-dark-primary-dark flex items-center justify-center gap-2"
                >
                  Send Message
                </button>
              </form>
            </div>
          </motion.div>

          {/* Contact Information */}
          <motion.div
            variants={stagger}
            initial="initial"
            whileInView="animate"
            viewport={{ once: true }}
            className="space-y-4 sm:space-y-6"
          >
            {contactInfo.map((info, index) => (
              <motion.a
                key={info.title}
                href={info.link}
                target="_blank"
                rel="noopener noreferrer"
                {...fadeInUp}
                transition={{ delay: index * 0.1 }}
                className="card-bg-alternate flex items-center p-6 rounded-xl shadow-lg hover:shadow-xl transition-shadow"
              >
                <div className="w-12 h-12 bg-primary/10 dark:bg-dark-primary/10 rounded-lg flex items-center justify-center text-primary dark:text-dark-primary">
                  {info.icon}
                </div>
                <div className="ml-6">
                  <h3 className="text-lg font-semibold dark:text-white">
                    {info.title}
                  </h3>
                  <p className="text-gray-600 dark:text-gray-300">
                    {info.details}
                  </p>
                </div>
              </motion.a>
            ))}
          </motion.div>
        </div>
      </div>
    </section>
  );
};

export default Contact;
