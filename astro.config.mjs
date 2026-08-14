import { defineConfig, fontProviders } from 'astro/config';
import sitemap from '@astrojs/sitemap';

function injectRobotsSitemap() {
  return {
    name: 'inject-robots-sitemap',
    hooks: {
      'astro:build:done': async ({ dir }) => {
        if (!process.env.SITE_URL) return;

        const { readFile, writeFile } = await import('node:fs/promises');
        const { join } = await import('node:path');
        const { fileURLToPath } = await import('node:url');

        const robotsPath = join(fileURLToPath(dir), 'robots.txt');

        const siteUrl = process.env.SITE_URL
          .replace(/^http:\/\//, 'https://')
          .replace(/\/?$/, '');

        const content = await readFile(robotsPath, 'utf-8');

        if (!content.includes('Sitemap:')) {
          await writeFile(
            robotsPath,
            `${content.trim()}\nSitemap: ${siteUrl}/sitemap-index.xml\n`
          );
        }
      },
    },
  };
}

function stripHtmlComments() {
  return {
    name: 'strip-html-comments',
    hooks: {
      'astro:build:done': async ({ dir }) => {
        const { readdir, readFile, writeFile } =
          await import('node:fs/promises');
        const { join } = await import('node:path');
        const { fileURLToPath } = await import('node:url');

        const distPath = fileURLToPath(dir);

        async function walk(current) {
          const entries = await readdir(current, { withFileTypes: true });

          await Promise.all(
            entries.map(async (entry) => {
              const full = join(current, entry.name);

              if (entry.isDirectory()) {
                return walk(full);
              }

              if (!entry.name.endsWith('.html')) {
                return;
              }

              const html = await readFile(full, 'utf-8');

              await writeFile(
                full,
                html.replace(/<!--(?!!)([\s\S]*?)-->/g, '')
              );
            })
          );
        }

        await walk(distPath);
      },
    },
  };
}

// GitHub Pages
// Repository: JulianRH15.github.io
// Site: https://JulianRH15.github.io

export default defineConfig({
  site:
    process.env.SITE_URL?.replace(/^http:\/\//, 'https://') ||
    'https://JulianRH15.github.io',

  base: process.env.BASE_PATH || '/',

  trailingSlash: 'never',

  output: 'static',

  compressHTML: true,

  scopedStyleStrategy: 'attribute',

  integrations: [
    sitemap(),
    injectRobotsSitemap(),
    stripHtmlComments(),
  ],

  fonts: [
    {
      provider: fontProviders.google(),
      name: 'Inter',
      cssVariable: '--font-inter',
    },
    {
      provider: fontProviders.google(),
      name: 'Oswald',
      cssVariable: '--font-oswald',
      weights: [400, 700],
    },
  ],

  image: {
    remotePatterns: [
      { hostname: 'raw.githubusercontent.com' },
      { hostname: 'user-images.githubusercontent.com' },
      { hostname: 'camo.githubusercontent.com' },
    ],

    service: {
      config: {
        jpeg: {
          mozjpeg: true,
        },
        webp: {
          effort: 4,
        },
        avif: {
          effort: 4,
          chromaSubsampling: '4:2:0',
        },
      },
    },
  },
});