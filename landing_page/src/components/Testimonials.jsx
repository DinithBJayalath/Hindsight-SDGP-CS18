import { motion, AnimatePresence } from "framer-motion";
import { useState } from "react";
import { FiChevronLeft, FiChevronRight, FiStar } from "react-icons/fi";
import { fadeIn, scaleIn, fadeInUp } from "../utils/animations";

const testimonials = [
  {
    id: 1,
    name: "Jessica Thompson",
    role: "Student",
    content:
      "HindSight has been a game-changer for my mental health journey. The AI-powered insights help me understand my emotions better.",
    rating: 5,
  },
  {
    id: 2,
    name: "David Wilson",
    role: "Professional",
    content:
      "As someone who's always on the go, HindSight makes it easy to maintain my mental well-being. The guided reflections are incredibly helpful.",
    rating: 5,
  },
  {
    id: 3,
    name: "Maria Rodriguez",
    role: "Teacher",
    content:
      "The mood tracking feature has helped me identify patterns in my emotional well-being. It's like having a personal mental health assistant.",
    rating: 5,
  },
];

const Testimonials = () => {
  const [currentIndex, setCurrentIndex] = useState(0);

  const nextTestimonial = () => {
    setCurrentIndex((prev) => (prev + 1) % testimonials.length);
  };

  const prevTestimonial = () => {
    setCurrentIndex((prev) =>
      prev === 0 ? testimonials.length - 1 : prev - 1
    );
  };

  return (
    <section
      id="testimonials"
      className="section-bg section-bg-alternate section-padding"
    >
      <div className="section-gradient" />
      <div className="container">
        <div className="section-inner">
          <div className="section-content">
            <motion.div {...fadeInUp} className="section-header">
              <h2 className="text-3xl lg:text-4xl font-bold mb-4 dark:text-white">
                What Our Users Say
              </h2>
              <p className="text-gray-600 dark:text-gray-300">
                Read how HindSight has helped people improve their mental
                well-being and daily life.
              </p>
            </motion.div>

            <div className="max-w-4xl mx-auto px-4 sm:px-8">
              <div className="relative">
                <AnimatePresence mode="wait">
                  <motion.div
                    key={currentIndex}
                    {...scaleIn}
                    className="glass-card rounded-2xl p-8 relative overflow-hidden group"
                  >
                    <div className="absolute top-0 right-0 w-32 h-32 bg-gradient-to-br from-primary/10 to-transparent rounded-full blur-2xl transform translate-x-16 -translate-y-16 group-hover:scale-150 transition-transform duration-700" />

                    <div className="relative z-10">
                      <div className="flex justify-center mb-4">
                        {[...Array(testimonials[currentIndex].rating)].map(
                          (_, i) => (
                            <FiStar
                              key={i}
                              className="w-5 h-5 text-yellow-400 fill-current"
                            />
                          )
                        )}
                      </div>
                      <p className="text-gray-600 dark:text-gray-300 text-lg mb-6">
                        "{testimonials[currentIndex].content}"
                      </p>
                      <div>
                        <h4 className="font-semibold dark:text-white">
                          {testimonials[currentIndex].name}
                        </h4>
                        <p className="text-gray-500 dark:text-gray-400">
                          {testimonials[currentIndex].role}
                        </p>
                      </div>
                    </div>
                  </motion.div>
                </AnimatePresence>

                <button
                  onClick={prevTestimonial}
                  className="absolute left-0 top-1/2 -translate-y-1/2 -translate-x-4 sm:-translate-x-12 bg-white/80 dark:bg-gray-800/80 rounded-full p-2 backdrop-blur-sm"
                >
                  <FiChevronLeft className="w-6 h-6 text-gray-600 dark:text-gray-300" />
                </button>
                <button
                  onClick={nextTestimonial}
                  className="absolute right-0 top-1/2 -translate-y-1/2 translate-x-12 p-2 text-gray-400 hover:text-primary dark:hover:text-dark-primary transition-colors"
                >
                  <FiChevronRight className="w-6 h-6 text-gray-600 dark:text-gray-300" />
                </button>
              </div>

              <div className="flex justify-center mt-6 space-x-2">
                {testimonials.map((_, index) => (
                  <button
                    key={index}
                    onClick={() => setCurrentIndex(index)}
                    className={`w-2 h-2 rounded-full transition-colors ${
                      index === currentIndex
                        ? "bg-primary dark:bg-dark-primary"
                        : "bg-gray-300 dark:bg-gray-600"
                    }`}
                  />
                ))}
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
};

export default Testimonials;
