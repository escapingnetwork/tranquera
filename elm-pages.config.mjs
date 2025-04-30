import { defineConfig } from "vite";
import tailwindcss from "@tailwindcss/vite";

export default {
  vite: defineConfig({ plugins: [tailwindcss()] }),
  headTagsTemplate(context) {
    return `
<link rel="preload" href="/style.css" as="style" />
<link rel="stylesheet" href="/style.css" />
<link rel="icon" href="/media/logo.svg">
<link rel="mask-icon" href="/media/logo.svg" color="#000000">
<link rel="apple-touch-icon" href="logo-180.png">
<meta name="generator" content="elm-pages v${context.cliVersion}" />
<script defer data-domain="tranquera.co" src="https://plausible.escaping.network/js/script.outbound-links.js"></script>

`;
//  <link rel="manifest" href="manifest.json">

  },
  preloadTagForFile(file) {
    // add preload directives for JS assets and font assets, etc., skip for CSS files
    // this function will be called with each file that is procesed by Vite, including any files in your headTagsTemplate in your config
    return !file.endsWith(".css");
  },
};
