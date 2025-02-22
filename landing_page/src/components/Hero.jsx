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
    <section id="home" className="section-bg section-bg-light pt-20 lg:pt-24">
      <div className="section-gradient" />
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
          <motion.div className="relative z-10">
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.8, delay: 0.5 }}
              className="relative"
            >
              <motion.img
                src="/Pixel 9 Pro.png"
                alt="HindSight App"
                className="w-full max-w-[200px] sm:max-w-[240px] lg:max-w-[280px] drop-shadow-2xl"
              />

              {/* Modern Gradient Orbs */}
              <motion.div
                animate={{
                  scale: [1, 1.1, 1],
                  rotate: [0, 90, 0],
                }}
                transition={{
                  duration: 8,
                  repeat: Infinity,
                  ease: "linear",
                }}
                className="absolute -top-20 -right-20 w-48 h-48 bg-gradient-to-r from-primary/50 to-secondary/50 rounded-full blur-3xl z-10"
              />
              <motion.div
                animate={{
                  scale: [1.1, 1, 1.1],
                  rotate: [0, -90, 0],
                }}
                transition={{
                  duration: 8,
                  repeat: Infinity,
                  ease: "linear",
                  delay: 4,
                }}
                className="absolute -bottom-20 -left-20 w-48 h-48 bg-gradient-to-r from-secondary/50 to-primary/50 rounded-full blur-3xl z-10"
              />

              {/* Floating UI Elements */}
              <motion.div
                animate={{ y: [-8, 8, -8], x: [-5, 5, -5] }}
                transition={{
                  duration: 5,
                  repeat: Infinity,
                  ease: "easeInOut",
                }}
                className="absolute top-10 -right-10 w-20 h-20 bg-primary/40 dark:bg-white/5 backdrop-blur-lg rounded-2xl border-2 border-primary/50 shadow-[0_8px_32px_rgba(0,0,0,0.1)] z-30"
              />
              <motion.div
                animate={{ y: [8, -8, 8], x: [5, -5, 5] }}
                transition={{
                  duration: 5,
                  repeat: Infinity,
                  ease: "easeInOut",
                  delay: 2.5,
                }}
                className="absolute bottom-20 -left-12 w-16 h-16 bg-secondary/40 dark:bg-white/5 backdrop-blur-lg rounded-2xl border-2 border-secondary/50 shadow-[0_8px_32px_rgba(0,0,0,0.1)] z-30"
              />

              {/* Subtle Shine Effect */}
              <motion.div
                animate={{
                  opacity: [0, 0.5, 0],
                  rotateZ: [0, 360],
                  scale: [0.8, 1.2, 0.8],
                }}
                transition={{
                  duration: 10,
                  repeat: Infinity,
                  ease: "linear",
                }}
                className="absolute inset-0 bg-gradient-conic from-primary/0 via-primary/30 to-primary/0 z-20 rounded-[40px]"
              />
            </motion.div>
          </motion.div>
        </div>
      </div>

      {/* Background Effect */}
      <div className="absolute inset-0 bg-[radial-gradient(circle_at_50%_50%,rgba(var(--primary-rgb),0.2),transparent_50%)] dark:bg-[radial-gradient(circle_at_50%_50%,rgba(107,169,217,0.1),transparent_50%)] z-0" />
    </section>
  );
};

export default Hero;
