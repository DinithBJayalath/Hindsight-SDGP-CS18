import { motion } from "framer-motion";
import { fadeInUp, fadeInLeft, fadeInRight } from "../utils/animations";

const AppShowcase = () => {
  return (
    <section className="section-bg section-bg-light py-20">
      <div className="section-gradient" />
      <div className="container mx-auto px-6">
        <motion.div
          {...fadeInUp}
          className="text-center max-w-3xl mx-auto mb-16"
        >
          <h2 className="text-3xl lg:text-4xl font-bold mb-4 dark:text-white">
            Experience HindSight
          </h2>
          <p className="text-gray-600 dark:text-gray-300">
            A seamless interface designed for your mental well-being journey
          </p>
        </motion.div>

        <div className="relative max-w-6xl mx-auto">
          {/* Center Phone */}
          <motion.div
            {...fadeInUp}
            className="relative z-20 flex justify-center"
          >
            <img
              src="/mockups/center.png"
              alt="HindSight Main Screen"
              className="w-[280px] md:w-[320px] drop-shadow-2xl"
            />
          </motion.div>

          {/* Left Phone */}
          <motion.div
            {...fadeInLeft}
            className="absolute top-20 left-4 md:left-20 lg:left-40 z-10 hidden md:block"
          >
            <img
              src="/mockups/left.png"
              alt="HindSight Journal Screen"
              className="w-[240px] md:w-[280px] drop-shadow-xl opacity-90"
            />
          </motion.div>

          {/* Right Phone */}
          <motion.div
            {...fadeInRight}
            className="absolute top-20 right-4 md:right-20 lg:right-40 z-10 hidden md:block"
          >
            <img
              src="/mockups/right.png"
              alt="HindSight Analytics Screen"
              className="w-[240px] md:w-[280px] drop-shadow-xl opacity-90"
            />
          </motion.div>

          {/* Floating Elements */}
          <div className="absolute inset-0 pointer-events-none">
            <div className="absolute top-1/4 left-1/4 w-32 h-32 bg-primary/20 dark:bg-dark-primary/20 rounded-full blur-3xl" />
            <div className="absolute bottom-1/4 right-1/4 w-32 h-32 bg-secondary/20 dark:bg-dark-secondary/20 rounded-full blur-3xl" />
          </div>
        </div>
      </div>
    </section>
  );
};

export default AppShowcase;
