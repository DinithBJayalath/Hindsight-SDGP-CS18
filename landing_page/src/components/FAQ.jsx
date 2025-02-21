import { motion } from "framer-motion";
import { useState } from "react";
import { FiChevronDown } from "react-icons/fi";
import { fadeInUp, stagger } from "../utils/animations";

const faqs = [
  {
    question: "What is HindSight?",
    answer:
      "HindSight is an AI-powered mental wellness app that helps you track emotions, journal your thoughts, and gain personalized insights for better mental well-being.",
  },
  {
    question: "How does the AI analysis work?",
    answer:
      "Our advanced LLM analyzes your journal entries to identify emotional patterns, provide personalized insights, and suggest coping strategies tailored to your needs.",
  },
  {
    question: "Is my data private and secure?",
    answer:
      "Yes, your privacy is our top priority. All data is encrypted, and we follow strict security protocols. Your personal information is never shared without your consent.",
  },
  {
    question: "Can I use HindSight offline?",
    answer:
      "Yes, you can write journal entries offline. They'll sync automatically when you're back online, ensuring you never lose your thoughts.",
  },
  {
    question: "Is there a free trial?",
    answer:
      "Yes! We offer a 14-day free trial with full access to all features. No credit card required to start.",
  },
];

const FAQ = () => {
  const [activeIndex, setActiveIndex] = useState(null);

  return (
    <section id="faq" className="section-bg section-bg-light py-20">
      <div className="section-gradient" />
      <div className="container mx-auto px-6 relative z-10">
        <motion.div
          {...fadeInUp}
          className="text-center max-w-3xl mx-auto mb-16"
        >
          <h2 className="text-3xl lg:text-4xl font-bold mb-4 dark:text-white">
            Frequently Asked Questions
          </h2>
          <p className="text-gray-600 dark:text-gray-300">
            Everything you need to know about HindSight and how it works.
          </p>
        </motion.div>

        <motion.div
          variants={stagger}
          initial="initial"
          whileInView="animate"
          viewport={{ once: true }}
          className="max-w-3xl mx-auto space-y-4"
        >
          {faqs.map((faq, index) => (
            <motion.div
              key={index}
              {...fadeInUp}
              className="bg-white dark:bg-gray-800 rounded-xl shadow-lg overflow-hidden"
            >
              <button
                onClick={() =>
                  setActiveIndex(activeIndex === index ? null : index)
                }
                className="w-full px-6 py-4 text-left flex items-center justify-between hover:bg-gray-50 dark:hover:bg-gray-700/50 transition-colors"
              >
                <span className="font-medium text-gray-900 dark:text-white">
                  {faq.question}
                </span>
                <FiChevronDown
                  className={`w-5 h-5 text-gray-500 transition-transform ${
                    activeIndex === index ? "rotate-180" : ""
                  }`}
                />
              </button>
              <div
                className={`px-6 transition-all duration-200 ease-in-out ${
                  activeIndex === index ? "py-4" : "h-0 overflow-hidden"
                }`}
              >
                <p className="text-gray-600 dark:text-gray-300">{faq.answer}</p>
              </div>
            </motion.div>
          ))}
        </motion.div>
      </div>
    </section>
  );
};

export default FAQ;
