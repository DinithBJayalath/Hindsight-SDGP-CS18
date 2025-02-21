import { motion } from "framer-motion";
import { FiArrowRight } from "react-icons/fi";
import { Link } from "react-scroll";
// Temporary: Comment out image until we have one
import {
  fadeIn,
  slideIn,
  fadeInUp,
  fadeInLeft,
  fadeInRight,
  stagger,
} from "../utils/animations";

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
            {...stagger}
            className="text-center lg:text-left order-2 lg:order-1"
          >
            <motion.h1
              {...fadeInUp}
              className="text-4xl lg:text-6xl font-bold leading-tight mb-6 dark:text-white"
            >
              <motion.span {...fadeInLeft} className="inline-block">
                Reflect.
              </motion.span>{" "}
              <motion.span
                {...fadeInUp}
                className="inline-block text-primary dark:text-dark-primary"
              >
                Heal.
              </motion.span>{" "}
              <motion.span {...fadeInRight} className="inline-block">
                Grow.
              </motion.span>
            </motion.h1>

            <motion.p
              {...fadeInUp}
              className="text-lg text-gray-600 dark:text-gray-300 mb-8 max-w-xl mx-auto lg:mx-0"
            >
              HindSight helps you track your emotions, reflect on your mental
              well-being, and discover insights to improve your daily life.
            </motion.p>

            <motion.div
              {...fadeInUp}
              className="flex flex-wrap justify-center lg:justify-start gap-4"
            >
              {/* Get Started Button - Scrolls to Features section */}
              <Link
                to="features"
                smooth={true}
                duration={500}
                className="btn-primary dark:bg-dark-primary dark:hover:bg-dark-primary-dark flex items-center gap-2 cursor-pointer"
              >
                Get Started
                <FiArrowRight />
              </Link>

              {/* Learn More Button - Scrolls to About section */}
              <Link
                to="features"
                smooth={true}
                duration={500}
                offset={-100}
                className="btn-secondary dark:border-dark-primary dark:text-dark-primary dark:hover:bg-dark-primary/10 cursor-pointer"
              >
                Learn More
              </Link>
            </motion.div>
          </motion.div>

          {/* App Mockup */}
          <motion.div
            {...fadeInRight}
            className="relative order-1 lg:order-2 flex justify-end pr-[10%]"
          >
            <div className="relative z-10">
              <motion.img
                {...fadeInUp}
                src="/Pixel 9 Pro.png"
                alt="HindSight App"
                className="w-full max-w-[200px] sm:max-w-[240px] lg:max-w-[280px] drop-shadow-2xl animate-float"
              />
            </div>
            {/* Decorative Background Elements */}
            <motion.div
              {...fadeInUp}
              className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[120%] h-[120%] rounded-full bg-gradient-to-r from-primary/20 to-secondary/20 dark:from-dark-primary/20 dark:to-dark-secondary/20 blur-3xl -z-10"
            />
          </motion.div>
        </div>
      </div>
    </section>
  );
};

export default Hero;
