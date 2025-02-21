import { motion } from "framer-motion";
import { fadeInUp, fadeInLeft, fadeInRight } from "../utils/animations";

const AppShowcase = () => {
  return (
    <section className="section-bg section-bg-light section-padding">
      <div className="section-gradient" />
      <div className="container">
        <div className="section-inner">
          <div className="section-content">
            <motion.div {...fadeInUp} className="section-header">
              <h2 className="text-3xl lg:text-4xl font-bold mb-4 dark:text-white">
                Experience HindSight
              </h2>
              <p className="text-gray-600 dark:text-gray-300">
                A seamless interface designed for your mental well-being journey
              </p>
            </motion.div>

            <div className="relative max-w-6xl mx-auto min-h-[400px] md:min-h-[500px]">
              {/* Center Phone */}
              <motion.div
                initial={{ opacity: 0, y: 50 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{
                  duration: 1.2,
                  type: "spring",
                  bounce: 0.3,
                  delay: 0.2,
                }}
                className="relative z-20 flex justify-center"
              >
                <motion.img
                  src="/mockups/center.png"
                  alt="HindSight Main Screen"
                  className="w-[280px] md:w-[320px] drop-shadow-2xl relative z-20"
                  whileHover={{
                    scale: 1.05,
                    y: -10,
                    transition: { duration: 0.3 },
                  }}
                />
              </motion.div>

              {/* Left Phone */}
              <motion.div
                initial={{ opacity: 0, x: -100 }}
                whileInView={{ opacity: 1, x: 0 }}
                viewport={{ once: true }}
                transition={{
                  duration: 1.2,
                  delay: 0.4,
                  type: "spring",
                  bounce: 0.3,
                }}
                className="absolute top-20 left-4 md:left-20 lg:left-40 z-10 hidden md:block hover:z-30"
                whileHover={{
                  scale: 1.15,
                  rotate: -5,
                  y: -50,
                  x: 30,
                  transition: {
                    type: "spring",
                    stiffness: 300,
                    damping: 15,
                  },
                }}
              >
                <motion.img
                  src="/mockups/left.png"
                  alt="HindSight Journal Screen"
                  className="w-[240px] md:w-[280px] drop-shadow-xl opacity-90 transition-all duration-300"
                  whileHover={{
                    scale: 1.05,
                    transition: { duration: 0.2 },
                  }}
                />
                <motion.div
                  className="absolute inset-0 bg-gradient-to-tr from-primary/20 to-transparent rounded-[40px] opacity-0 transition-opacity duration-300"
                  whileHover={{ opacity: 1 }}
                />
              </motion.div>

              {/* Right Phone */}
              <motion.div
                initial={{ opacity: 0, x: 100 }}
                whileInView={{ opacity: 1, x: 0 }}
                viewport={{ once: true }}
                transition={{
                  duration: 1.2,
                  delay: 0.6,
                  type: "spring",
                  bounce: 0.3,
                }}
                className="absolute top-20 right-4 md:right-20 lg:right-40 z-10 hidden md:block hover:z-30"
                whileHover={{
                  scale: 1.15,
                  rotate: 5,
                  y: -50,
                  x: -30,
                  transition: {
                    type: "spring",
                    stiffness: 300,
                    damping: 15,
                  },
                }}
              >
                <motion.img
                  src="/mockups/right.png"
                  alt="HindSight Analytics Screen"
                  className="w-[240px] md:w-[280px] drop-shadow-xl opacity-90 transition-all duration-300"
                  whileHover={{
                    scale: 1.05,
                    transition: { duration: 0.2 },
                  }}
                />
                <motion.div
                  className="absolute inset-0 bg-gradient-to-tl from-secondary/20 to-transparent rounded-[40px] opacity-0 transition-opacity duration-300"
                  whileHover={{ opacity: 1 }}
                />
              </motion.div>

              {/* Animated Gradient Orbs */}
              <motion.div
                initial={{ opacity: 0 }}
                whileInView={{ opacity: 1 }}
                transition={{ duration: 1 }}
                className="absolute inset-0 pointer-events-none"
              >
                <motion.div
                  animate={{
                    scale: [1, 1.2, 1],
                    opacity: [0.3, 0.5, 0.3],
                  }}
                  transition={{
                    duration: 6,
                    repeat: Infinity,
                    ease: "easeInOut",
                  }}
                  className="absolute top-1/4 left-1/4 w-32 h-32 bg-primary/20 dark:bg-dark-primary/20 rounded-full blur-3xl"
                />
                <motion.div
                  animate={{
                    scale: [1, 1.2, 1],
                    opacity: [0.3, 0.5, 0.3],
                  }}
                  transition={{
                    duration: 6,
                    repeat: Infinity,
                    ease: "easeInOut",
                    delay: 3,
                  }}
                  className="absolute bottom-1/4 right-1/4 w-32 h-32 bg-secondary/20 dark:bg-dark-secondary/20 rounded-full blur-3xl"
                />
              </motion.div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
};

export default AppShowcase;
