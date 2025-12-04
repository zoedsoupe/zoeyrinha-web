/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./js/**/*.js", "../lib/zoeyrinha_web/**/*.*ex"],
  theme: {
    extend: {
      colors: {
        // Nyxvamp Veil palette
        background: "#1E1E2E", // Dark purple background
        foreground: "#D9E0EE", // Light lavender text
        cursorline: "#2E2E3E",
        selection: "#494D64",

        pink: {
          DEFAULT: "#F5C2E7", // Keywords, headings, CTAs
          soft: "#F28FAD", // Constants, errors, accents
        },
        blue: {
          DEFAULT: "#96CDFB", // Functions, links
        },
        green: {
          DEFAULT: "#ABE9B3", // Strings, success states
          soft: "#A6DA95", // Success badges
        },
        lavender: {
          DEFAULT: "#C9CBFF", // Types, secondary text
        },
        peach: {
          DEFAULT: "#F8BD96", // Numbers, warnings
        },
        gray: {
          DEFAULT: "#6E6A86", // Comments, muted text
          light: "#D9E0EE",
          dark: "#2A2A3C",
        },
      },
      fontFamily: {
        sans: ["Inter", "sans-serif"],
        mono: ["JetBrains Mono", "monospace"],
      },
    },
  },
  plugins: [],
};
