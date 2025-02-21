import { motion } from "framer-motion";
import { FiLinkedin, FiGithub } from "react-icons/fi";

const teamMembers = [
  {
    name: "Dinith Jayalath",
    role: "Team Leader",
    image: "/team/dinith.jpg", // We'll add these images later
    linkedin: "https://linkedin.com",
    github: "https://github.com",
  },
  {
    name: "Achintha Ekanayake",
    role: "Team Member",
    image: "/team/achintha.jpg",
    linkedin: "https://linkedin.com",
    github: "https://github.com",
  },
  {
    name: "Ruwantha Ekanayake",
    role: "Team Member",
    image: "/team/ruwantha.jpg",
    linkedin: "https://linkedin.com",
    github: "https://github.com",
  },
  {
    name: "Ramudi Hearth",
    role: "Team Member",
    image: "/team/ramudi.jpg",
    linkedin: "https://linkedin.com",
    github: "https://github.com",
  },
  {
    name: "Suhas Jayalath",
    role: "Team Member",
    image: "/team/suhas.jpg",
    linkedin: "https://linkedin.com",
    github: "https://github.com",
  },
  {
    name: "Kavindu Rajapaksha",
    role: "Team Member",
    image: "/team/kavindu.jpg",
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
              className="bg-white dark:bg-gray-800 rounded-xl shadow-lg p-6 text-center transform hover:scale-105 transition-transform duration-300 w-full flex flex-col"
            >
              <div className="relative w-32 h-32 mx-auto mt-4 mb-6">
                <img
                  src={member.image}
                  alt={member.name}
                  className="rounded-full w-full h-full object-cover ring-2 ring-primary/20 dark:ring-dark-primary/20"
                />
              </div>
              <h3 className="text-xl font-semibold mb-3 dark:text-white">
                {member.name}
              </h3>
              <p className="text-gray-600 dark:text-gray-400 mb-6">
                {member.role}
              </p>
              <div className="flex items-center justify-center gap-4 mt-auto">
                <a
                  href={member.linkedin}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="p-2 text-gray-400 hover:text-primary dark:hover:text-dark-primary transition-colors"
                >
                  <FiLinkedin className="w-5 h-5" />
                </a>
                <a
                  href={member.github}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="p-2 text-gray-400 hover:text-primary dark:hover:text-dark-primary transition-colors"
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
