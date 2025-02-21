import { motion } from "framer-motion";
import { FiActivity, FiBarChart2, FiEdit, FiLock } from "react-icons/fi";
import { fadeIn, staggerContainer } from "../utils/animations";

const features = [
  {
    icon: <FiActivity className="w-6 h-6" />,
    title: "AI-powered Journaling",
    description:
      "Get personalized insights and analysis from our advanced AI system.",
  },
  {
    icon: <FiBarChart2 className="w-6 h-6" />,
    title: "Mood Tracking",
    description:
      "Visualize your emotional journey with interactive graphs and patterns.",
  },
  {
    icon: <FiEdit className="w-6 h-6" />,
    title: "Guided Reflections",
    description:
      "Follow personalized prompts designed to deepen your self-awareness.",
  },
  {
    icon: <FiLock className="w-6 h-6" />,
    title: "Private & Secure",
    description:
      "Your thoughts are protected with enterprise-grade encryption.",
  },
];

const Features = () => {
  return (
    <section
      id="features"
      className="py-20 bg-white/50 dark:bg-dark-bg-lighter"
    >
      <div className="container mx-auto px-6">
        <motion.div
          {...fadeIn}
          viewport={{ once: true }}
          transition={{ duration: 0.5 }}
          className="text-center mb-16"
        >
          <h2 className="text-3xl lg:text-4xl font-bold mb-4 dark:text-white">
            Transform Your Journey
          </h2>
          <p className="text-gray-600 dark:text-gray-300 max-w-2xl mx-auto">
            Discover powerful tools designed to enhance your mental well-being
            and personal growth.
          </p>
        </motion.div>

        <motion.div
          variants={staggerContainer}
          initial="initial"
          whileInView="animate"
          viewport={{ once: true }}
          className="grid sm:grid-cols-2 lg:grid-cols-4 gap-6 lg:gap-8"
        >
          {features.map((feature, index) => (
            <motion.div
              key={feature.title}
              variants={fadeIn}
              viewport={{ once: true }}
              transition={{ duration: 0.5, delay: index * 0.1 }}
              className="bg-white dark:bg-dark-bg p-6 rounded-xl shadow-lg hover:shadow-xl transition-all hover:-translate-y-1 dark-hover:bg-dark-bg-lighter"
            >
              <div className="text-primary dark:text-dark-primary mb-4">
                {feature.icon}
              </div>
              <h3 className="text-xl font-semibold mb-2 dark:text-white">
                {feature.title}
              </h3>
              <p className="text-gray-600 dark:text-gray-300">
                {feature.description}
              </p>
            </motion.div>
          ))}
        </motion.div>
      </div>
    </section>
  );
};

export default Features;
