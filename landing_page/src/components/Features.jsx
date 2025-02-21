import { motion } from "framer-motion";
import { FiSmile, FiBookOpen, FiCpu } from "react-icons/fi";
import { fadeInUp, stagger } from "../utils/animations";

const features = [
  {
    icon: <FiSmile className="w-6 h-6" />,
    title: "Daily Mood Check-Ins",
    description:
      "Quick, emoji-based inputs that allow users to log their feelings easily. Track your emotional journey with simple, intuitive interactions.",
  },
  {
    icon: <FiBookOpen className="w-6 h-6" />,
    title: "In-Depth Journaling",
    description:
      "Express yourself freely with both text entry and speech-to-text options. Capture your thoughts and feelings in the way that feels most natural to you.",
  },
  {
    icon: <FiCpu className="w-6 h-6" />,
    title: "AI-Driven Mood Analysis",
    description:
      "Our customized large language model (LLM) analyzes your journal entries to provide personalized insights and patterns in your emotional well-being.",
  },
];

const Features = () => {
  return (
    <section id="features" className="py-20 relative overflow-hidden">
      <div className="absolute inset-0 bg-gradient-to-b from-transparent via-primary/5 to-transparent dark:via-dark-primary/5" />
      <div className="container mx-auto px-6">
        <motion.div
          {...fadeInUp}
          className="text-center max-w-3xl mx-auto mb-16"
        >
          <h2 className="text-3xl lg:text-4xl font-bold mb-4 dark:text-white">
            Features That Empower Your Journey
          </h2>
          <p className="text-gray-600 dark:text-gray-300">
            Discover tools designed to support your mental well-being and
            personal growth
          </p>
        </motion.div>

        <motion.div
          variants={stagger}
          initial="initial"
          whileInView="animate"
          viewport={{ once: true }}
          className="grid md:grid-cols-2 lg:grid-cols-3 gap-8 max-w-7xl mx-auto"
        >
          {features.map((feature, index) => (
            <motion.div
              key={feature.title}
              {...fadeInUp}
              transition={{ delay: index * 0.2 }}
              className="bg-white dark:bg-gray-800 rounded-xl p-8 shadow-lg hover:shadow-xl transition-shadow duration-300"
            >
              <div className="w-12 h-12 bg-primary/10 dark:bg-dark-primary/10 rounded-lg flex items-center justify-center mb-6">
                <span className="text-primary dark:text-dark-primary">
                  {feature.icon}
                </span>
              </div>
              <h3 className="text-xl font-semibold mb-4 dark:text-white">
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
