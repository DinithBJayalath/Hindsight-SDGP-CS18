import { motion, AnimatePresence } from "framer-motion";
import { useState } from "react";
import { FiChevronDown, FiChevronUp } from "react-icons/fi";
import { fadeIn, slideIn } from "../utils/animations";

const faqs = [
  {
    question: "How does HindSight's AI journaling work?",
    answer:
      "HindSight uses advanced natural language processing to analyze your journal entries, identifying patterns in your emotions and thoughts. It provides personalized insights and suggestions to help you better understand yourself.",
  },
  {
    question: "Is my data private and secure?",
    answer:
      "Yes, absolutely! We use enterprise-grade encryption to protect your data. Your journal entries are private and can only be accessed by you. We never share your personal information with third parties.",
  },
  {
    question: "Can I export my journal entries?",
    answer:
      "Yes, you can export your journal entries and insights in various formats including PDF and plain text. This feature helps you keep a backup of your thoughts and track your progress over time.",
  },
  {
    question: "Is there a free trial available?",
    answer:
      "Yes! We offer a 14-day free trial with full access to all features. No credit card required. You can upgrade to a premium plan anytime during or after the trial period.",
  },
];

const FAQ = () => {
  const [openIndex, setOpenIndex] = useState(null);

  return (
    <section
      id="faq"
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
            Frequently Asked Questions
          </h2>
          <p className="text-gray-600 dark:text-gray-300 max-w-2xl mx-auto">
            Find answers to common questions about HindSight and how it can help
            you on your mental health journey.
          </p>
        </motion.div>

        <div className="max-w-3xl mx-auto space-y-4">
          {faqs.map((faq, index) => (
            <motion.div
              key={index}
              {...fadeIn}
              viewport={{ once: true }}
              transition={{ duration: 0.5, delay: index * 0.1 }}
            >
              <button
                onClick={() => setOpenIndex(openIndex === index ? null : index)}
                className="w-full flex items-center justify-between p-4 sm:p-6 bg-white dark:bg-dark-bg rounded-lg shadow-md hover:shadow-lg transition-all dark-hover:bg-dark-bg-lighter group"
              >
                <span className="font-semibold text-left dark:text-white">
                  {faq.question}
                </span>
                {openIndex === index ? (
                  <FiChevronUp className="w-5 h-5 text-primary dark:text-dark-primary flex-shrink-0 ml-4 transform transition-transform group-hover:scale-110" />
                ) : (
                  <FiChevronDown className="w-5 h-5 text-gray-400 dark:text-gray-500 flex-shrink-0 ml-4 transform transition-transform group-hover:scale-110" />
                )}
              </button>
              <AnimatePresence>
                {openIndex === index && (
                  <motion.div
                    initial={{ height: 0, opacity: 0 }}
                    animate={{ height: "auto", opacity: 1 }}
                    exit={{ height: 0, opacity: 0 }}
                    transition={{ duration: 0.3 }}
                    className="px-6 py-4 bg-white dark:bg-dark-bg rounded-b-lg shadow-md"
                  >
                    <p className="text-gray-600 dark:text-gray-300">
                      {faq.answer}
                    </p>
                  </motion.div>
                )}
              </AnimatePresence>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  );
};

export default FAQ;
