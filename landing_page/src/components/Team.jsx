import { motion } from "framer-motion";
import { FiLinkedin, FiGithub } from "react-icons/fi";

const teamMembers = [
  {
    name: "Sarah Johnson",
    role: "Founder & CEO",
    image: "/team/sarah.jpg", // We'll add these images later
    linkedin: "https://linkedin.com",
    github: "https://github.com",
  },
  {
    name: "Michael Chen",
    role: "Lead Developer",
    image: "/team/michael.jpg",
    linkedin: "https://linkedin.com",
    github: "https://github.com",
  },
  {
    name: "Emily Rodriguez",
    role: "UX Designer",
    image: "/team/emily.jpg",
    linkedin: "https://linkedin.com",
    github: "https://github.com",
  },
  {
    name: "David Kim",
    role: "AI Engineer",
    image: "/team/david.jpg",
    linkedin: "https://linkedin.com",
    github: "https://github.com",
  },
  {
    name: "Lisa Thompson",
    role: "Product Manager",
    image: "/team/lisa.jpg",
    linkedin: "https://linkedin.com",
    github: "https://github.com",
  },
  {
    name: "James Wilson",
    role: "Marketing Director",
    image: "/team/james.jpg",
    linkedin: "https://linkedin.com",
    github: "https://github.com",
  },
];

const Team = () => {
  return (
    <section id="team" className="py-20 dark:bg-gray-900/30">
      <div className="container mx-auto px-6 max-w-7xl">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.5 }}
          className="text-center mb-16"
        >
          <h2 className="text-3xl lg:text-4xl font-bold mb-4 dark:text-white">
            Meet the Team Behind HindSight
          </h2>
          <p className="text-gray-600 dark:text-gray-300 max-w-2xl mx-auto">
            We're a passionate team dedicated to improving mental well-being
            through technology and innovation.
          </p>
        </motion.div>

        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8 max-w-6xl mx-auto">
          {teamMembers.map((member, index) => (
            <motion.div
              key={member.name}
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ duration: 0.5, delay: index * 0.1 }}
              className="bg-white dark:bg-gray-800 rounded-xl shadow-lg p-6 text-center transform hover:scale-105 transition-transform duration-300 w-full"
            >
              <div className="relative mb-6 w-32 h-32 mx-auto">
                <img
                  src={member.image}
                  alt={member.name}
                  className="rounded-full w-full h-full object-cover ring-2 ring-primary/20 dark:ring-dark-primary/20"
                />
              </div>
              <h3 className="text-xl font-semibold mb-2 dark:text-white">
                {member.name}
              </h3>
              <p className="text-gray-600 dark:text-gray-400 mb-4">
                {member.role}
              </p>
              <div className="flex justify-center space-x-4">
                <a
                  href={member.linkedin}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="text-gray-400 hover:text-primary dark:hover:text-dark-primary transition-colors"
                >
                  <FiLinkedin className="w-5 h-5" />
                </a>
                <a
                  href={member.github}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="text-gray-400 hover:text-primary dark:hover:text-dark-primary transition-colors"
                >
                  <FiGithub className="w-5 h-5" />
                </a>
              </div>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  );
};

export default Team;
