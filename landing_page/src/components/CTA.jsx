import { motion from "framer-motion";
import { FiDownload, FiArrowRight } from "react-icons/fi";
import { fadeIn, slideIn, staggerContainer } from "../utils/animations";

const CTA = () => {
  return (
    <section className="py-20 relative overflow-hidden">
      <div className="absolute inset-0">
        <div className="absolute in} set-0= bg-gradient-radial from-primary/30 to-transparent dark:from-dark-primary/20 animate-gradient-xy" />
        <div className="absolute inset-0 bg-gradient-conic from-secondary/10 via-transparent to-secondary/20 dark:from-dark-secondary/10 dark:to-dark-secondary/10 animate-gradient-x opacity-50" />
      </div>
      <div className="container mx-auto px-6">
        <motion.div
          {...fadeIn}
          viewport={{ once: true }}
          transition={{ duration: 0.5 }}
          className="max-w-4xl mx-auto text-center relative"
        >
          <h2 className="text-3xl lg:text-4xl font-bold mb-6 dark:text-black">
            Start Your Mental Health Journey Today
          </h2>
          <p className="text-lg text-black-600 dark:text-black-300 mb-8 max-w-2xl mx-auto">
            Join thousands of users who have transformed their lives with
            HindSight. Download now and get 14 days free trial.
          </p>
          <motion.div
            variants={staggerContainer}
            initial="initial"
            whileInView="animate"
            viewport={{ once: true }}
            className="flex flex-col sm:flex-row justify-center items-center gap-4"
          >
            <motion.button
              variants={slideIn}
              className="btn-primary dark:bg-dark-primary dark:hover:bg-dark-primary-dark flex items-center gap-2 w-full sm:w-auto backdrop-blur-sm supports-blur:bg-primary/90 dark:supports-blur:bg-dark-primary/90"
            >
              <FiDownload />
              <span>Download App</span>
            </motion.button>
            <motion.button
              variants={slideIn}
              className="btn-secondary dark:border-dark-primary dark:text-dark-primary dark:hover:bg-dark-primary/10 flex items-center gap-2 w-full sm:w-auto backdrop-blur-sm"
            >
              Learn More
              <FiArrowRight />
            </motion.button>
          </motion.div>
        </motion.div>
      </div>
    </section>
  );
};

export default CTA;
