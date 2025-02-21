import { motion } from "framer-motion";
import { FiDownload } from "react-icons/fi";
import { fadeIn } from "../utils/animations";

const CTA = () => {
  return (
    <section className="py-20 relative overflow-hidden">
      <div className="absolute inset-0">
        <div className="absolute inset-0 bg-gradient-radial from-primary/30 to-transparent dark:from-dark-primary/20 animate-gradient-xy" />
        <div className="absolute inset-0 bg-gradient-conic from-secondary/10 via-transparent to-secondary/20 dark:from-dark-secondary/10 dark:to-dark-secondary/10 animate-gradient-x opacity-50" />
      </div>
      <div className="container mx-auto px-6">
        <motion.div
          {...fadeIn}
          viewport={{ once: true }}
          transition={{ duration: 0.5 }}
          className="max-w-4xl mx-auto text-center relative"
        >
          <h2 className="text-3xl lg:text-4xl font-bold mb-6 dark:text-white">
            Start Your Mental Health Journey Today
          </h2>
          <p className="text-lg text-gray-600 dark:text-gray-300 mb-8 max-w-2xl mx-auto">
            Join thousands of users who have transformed their lives with
            HindSight. Download now and get 14 days free trial.
          </p>
          <div className="flex justify-center">
            <a
              href="#download"
              className="relative inline-flex items-center gap-2 px-8 py-4 bg-gradient-to-r from-primary to-secondary hover:from-primary/90 hover:to-secondary/90 text-white rounded-full font-semibold transition-all duration-300 transform hover:scale-105 group"
            >
              <FiDownload className="w-5 h-5" />
              <span>Download App</span>
              {/* Glow effect */}
              <div className="absolute inset-0 rounded-full bg-gradient-to-r from-primary to-secondary blur-xl opacity-50 group-hover:opacity-75 transition-opacity -z-10" />
            </a>
          </div>
        </motion.div>
      </div>
    </section>
  );
};

export default CTA;
