import { motion } from "framer-motion";
import { FiArrowRight } from "react-icons/fi";
// Temporary: Comment out image until we have one
import { fadeIn, slideIn } from "../utils/animations";

const Hero = () => {
  return (
    <section id="home" className="pt-20 lg:pt-24 relative overflow-hidden">
      <div className="absolute inset-0 -z-10">
        <div className="absolute inset-0 bg-gradient-radial from-primary/20 to-transparent dark:from-dark-primary/10 animate-gradient-xy" />
        <div className="absolute inset-0 bg-gradient-conic from-secondary/20 via-transparent to-secondary/20 dark:from-dark-secondary/10 dark:to-dark-secondary/10 animate-gradient-x opacity-50" />
      </div>
      <div className="container mx-auto px-6 py-12 lg:py-24">
        <div className="grid lg:grid-cols-2 gap-12 lg:gap-16 items-center">
          {/* Text Content */}
          <motion.div
            {...slideIn}
            transition={{ duration: 0.5 }}
            className="text-center lg:text-left order-2 lg:order-1"
          >
            <h1 className="text-4xl lg:text-6xl font-bold leading-tight mb-6 dark:text-white">
              Reflect.{" "}
              <span className="text-primary dark:text-dark-primary">Heal.</span>{" "}
              Grow.
            </h1>
            <p className="text-lg text-gray-600 dark:text-gray-300 mb-8 max-w-xl mx-auto lg:mx-0">
              HindSight helps you track your emotions, reflect on your mental
              well-being, and discover insights to improve your daily life.
            </p>
            <div className="flex flex-wrap justify-center lg:justify-start gap-4">
              <button className="btn-primary dark:bg-dark-primary dark:hover:bg-dark-primary-dark flex items-center gap-2">
                Get Started
                <FiArrowRight />
              </button>
              <button className="btn-secondary dark:border-dark-primary dark:text-dark-primary dark:hover:bg-dark-primary/10">
                Learn More
              </button>
            </div>
          </motion.div>

          {/* App Mockup */}
          <motion.div
            {...fadeIn}
            transition={{ duration: 0.5, delay: 0.2 }}
            className="relative order-1 lg:order-2"
          >
            <div className="relative z-10">
              {/* Temporary: Comment out image until we have one */}
              {/* <img
                src={mockupImage}
                alt="HindSight App"
                className="w-full max-w-[280px] sm:max-w-[320px] lg:max-w-md mx-auto"
              /> */}
            </div>
            {/* Decorative Background Elements */}
            <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[120%] h-[120%] rounded-full bg-gradient-to-r from-primary/20 to-secondary/20 dark:from-dark-primary/20 dark:to-dark-secondary/20 blur-3xl -z-10" />
          </motion.div>
        </div>
      </div>
    </section>
  );
};

export default Hero;
