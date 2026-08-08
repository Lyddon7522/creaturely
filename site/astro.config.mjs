// @ts-check
import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';

const siteUrl = process.env.SITE_URL?.trim();

export default defineConfig({
  output: 'static',
  site: siteUrl || undefined,
  trailingSlash: 'always',
  build: {
    inlineStylesheets: 'never',
  },
  integrations: siteUrl ? [sitemap()] : [],
});
