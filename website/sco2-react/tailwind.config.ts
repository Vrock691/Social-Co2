import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      backgroundImage: {
       "logo sco2":"url('website/sco2-react/public/logo_sco2.svg')",
       "image couverture":"url('website/sco2-react/public/jungle-601542_1280 1.svg')",
    },
  },
},
}
export default config;
