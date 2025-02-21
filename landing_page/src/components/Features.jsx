import { motion } from "framer-motion";
import {
  FiSmile,
  FiBookOpen,
  FiCpu,
  FiTarget,
  FiTrendingUp,
  FiAward,
} from "react-icons/fi";
import { fadeInUp, stagger } from "../utils/animations";

const features = [
  {
    icon: <FiTarget className="w-6 h-6" />,
    title: "Goal Setting & Tracking",
    description:
      "Set and track personal growth goals with visual progress meters. Our AI helps you stay motivated with custom reminders and milestone celebrations.",
  },
  {
    icon: <FiSmile className="w-6 h-6" />,
    title: "Daily Mood Check-Ins",
    description:
      "Quick, emoji-based inputs that allow you to log your feelings easily. Track your emotional journey with simple, intuitive interactions.",
  },
  {
    icon: <FiBookOpen className="w-6 h-6" />,
    title: "In-Depth Journaling",
    description:
      "Express yourself freely with both text entry and speech-to-text options. Capture your thoughts and feelings in the way that feels most natural to you.",
  },
  {
    icon: <FiCpu className="w-6 h-6" />,
    title: "AI-Driven Analysis",
    description:
      "Our customized LLM analyzes your journal entries to provide personalized insights and patterns in your emotional well-being.",
  },
  {
    icon: <FiTrendingUp className="w-6 h-6" />,
    title: "Progress Tracking",
    description:
      "Visualize your growth with interactive charts and progress indicators. Celebrate streaks and achievements as you maintain healthy habits.",
  },
  {
    icon: <FiAward className="w-6 h-6" />,
    title: "Achievement System",
    description:
      "Earn rewards and badges as you reach milestones in your mental wellness journey. Share and celebrate your progress with the community.",
  },
];

const Features = () => {
  return (
    <section
      id="features"
      className="section-bg section-bg-alternate section-padding"
    >
      <div className="section-gradient" />
      <div className="container">
        <div className="section-inner">
          <div className="section-content">
            <motion.div {...fadeInUp} className="section-header">
              <h2 className="text-3xl lg:text-4xl font-bold mb-4 dark:text-white">
                Features That Empower Your Journey
              </h2>
              <p className="text-gray-600 dark:text-gray-300">
                Discover powerful tools designed to support your mental
                well-being and personal growth journey
              </p>
            </motion.div>

            <motion.div
              variants={stagger}
              initial="initial"
              whileInView="animate"
              viewport={{ once: true }}
              className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 sm:gap-8"
            >
              {features.map((feature, index) => (
                <motion.div
                  key={feature.title}
                  {...fadeInUp}
                  transition={{ delay: index * 0.1 }}
                  className="glass-card rounded-2xl p-8 hover-lift group"
                >
                  <div
                    className="w-12 h-12 bg-gradient-to-br from-primary/10 to-secondary/10 
                                  dark:from-dark-primary/10 dark:to-dark-secondary/10 
                                  rounded-xl flex items-center justify-center mb-6
                                  group-hover:scale-110 transition-transform duration-300"
                  >
                    <span className="text-primary dark:text-dark-primary">
                      {feature.icon}
                    </span>
                  </div>
                  <h3 className="text-xl font-semibold mb-4 dark:text-white group-hover:gradient-text">
                    {feature.title}
                  </h3>
                  <p className="text-gray-600 dark:text-gray-300">
                    {feature.description}
                  </p>
                </motion.div>
              ))}
            </motion.div>
          </div>
        </div>
      </div>
    </section>
  );
};

export default Features;
