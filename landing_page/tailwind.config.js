/** @type {import('tailwindcss').Config} */
export default {
  darkMode: "class",
  content: ["./index.html", "./src/**/*.{js,ts,jsx,tsx}"],
  future: {
    hoverOnlyWhenSupported: true,
  },
  theme: {
    extend: {
      backgroundImage: {
        "gradient-radial": "radial-gradient(var(--tw-gradient-stops))",
        "gradient-conic":
          "conic-gradient(from 180deg at 50% 50%, var(--tw-gradient-stops))",
      },
      container: {
        screens: {
          sm: "640px",
          md: "768px",
          lg: "1024px",
          xl: "1280px",
        },
        center: true,
        padding: {
          DEFAULT: "1rem",
          sm: "2rem",
          lg: "4rem",
          xl: "5rem",
        },
      },
      screens: {
        xs: "475px",
        "2xl": "1536px",
        "hover-hover": { raw: "(hover: hover)" },
      },
      colors: {
        primary: "#8CD3FF",
        secondary: "#BFE6FF",
        "primary-dark": "#7BC0EC",
        "secondary-dark": "#A8D3EC",
        dark: {
          primary: "#6BA9D9",
          secondary: "#9EBFD9",
          "primary-dark": "#5A8FB8",
          "secondary-dark": "#8AA7BD",
          bg: {
            DEFAULT: "#121212",
            lighter: "#1E1E1E",
            darker: "#0A0A0A",
          },
        },
      },
      fontFamily: {
        sans: ["Inter", "sans-serif"],
      },
      spacing: {
        18: "4.5rem",
        88: "22rem",
        128: "32rem",
      },
      zIndex: {
        60: "60",
        70: "70",
        80: "80",
        90: "90",
        100: "100",
      },
      animation: {
        "gradient-x": "gradient-x 15s ease infinite",
        "gradient-y": "gradient-y 15s ease infinite",
        "gradient-xy": "gradient-xy 15s ease infinite",
      },
      keyframes: {
        "gradient-y": {
          "0%, 100%": {
            "background-size": "400% 400%",
            "background-position": "center top",
          },
          "50%": {
            "background-size": "200% 200%",
            "background-position": "center center",
          },
        },
        "gradient-x": {
          "0%, 100%": {
            "background-size": "200% 200%",
            "background-position": "left center",
          },
          "50%": {
            "background-size": "200% 200%",
            "background-position": "right center",
          },
        },
        "gradient-xy": {
          "0%, 100%": {
            "background-size": "400% 400%",
            "background-position": "left center",
          },
          "50%": {
            "background-size": "200% 200%",
            "background-position": "right center",
          },
        },
      },
    },
  },
  plugins: [
    function ({ addVariant }) {
      addVariant("supports-blur", "@supports (backdrop-filter: blur(0))");
      addVariant("supports-grid", "@supports (display: grid)");
      addVariant("supports-dark", "@media (prefers-color-scheme: dark)");
      addVariant("dark-hover", ".dark &:hover");
      addVariant("dark-focus", ".dark &:focus");
      addVariant("dark-active", ".dark &:active");
    },
  ],
};
