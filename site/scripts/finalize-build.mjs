import { createHash } from 'node:crypto';
import { copyFileSync, existsSync, readFileSync } from 'node:fs';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const scriptDirectory = dirname(fileURLToPath(import.meta.url));
const siteDirectory = resolve(scriptDirectory, '..');
const distDirectory = resolve(siteDirectory, 'dist');

copyFileSync(
  resolve(siteDirectory, 'staticwebapp.config.json'),
  resolve(distDirectory, 'staticwebapp.config.json'),
);

const expectedPages = [
  'index.html',
  'privacy/index.html',
  'support/index.html',
  'terms/index.html',
  '404.html',
];

function builtTarget(targetPath) {
  const relativePath = targetPath.replace(/^\/+/, '');
  if (targetPath === '/' || relativePath === '') {
    return resolve(distDirectory, 'index.html');
  }
  if (targetPath.endsWith('/')) {
    return resolve(distDirectory, relativePath, 'index.html');
  }
  return resolve(distDirectory, relativePath);
}

function contentSecurityPolicy(html, page) {
  const metaTag = [...html.matchAll(/<meta\b[^>]*>/gi)]
    .map((match) => match[0])
    .find((tag) => /\bhttp-equiv="content-security-policy"/i.test(tag));
  const content = metaTag?.match(/\bcontent="([^"]*)"/i)?.[1];

  if (!content) {
    throw new Error(`Built page is missing Astro's content security policy: ${page}`);
  }

  return new Map(
    content
      .split(';')
      .map((directive) => directive.trim().split(/\s+/))
      .filter(([name]) => name)
      .map(([name, ...sources]) => [name, sources]),
  );
}

function contentHash(content) {
  const hash = createHash('sha256').update(content).digest('base64');
  return `'sha256-${hash}'`;
}

for (const page of expectedPages) {
  const path = resolve(distDirectory, page);
  if (!existsSync(path)) {
    throw new Error(`Expected built page is missing: ${page}`);
  }

  const html = readFileSync(path, 'utf8');
  if (html.includes('—')) {
    throw new Error(`Built page contains an em dash: ${page}`);
  }

  const csp = contentSecurityPolicy(html, page);
  const requiredSources = new Map([
    ['default-src', ["'self'"]],
    ['img-src', ["'self'", 'data:']],
    ['connect-src', ["'self'"]],
    ['font-src', ["'self'"]],
    ['base-uri', ["'self'"]],
    ['form-action', ["'none'"]],
    ['object-src', ["'none'"]],
    ['script-src', ["'self'"]],
    ['style-src', ["'self'"]],
  ]);

  for (const [directive, expectedSources] of requiredSources) {
    const sources = csp.get(directive) ?? [];
    for (const source of expectedSources) {
      if (!sources.includes(source)) {
        throw new Error(`Built page CSP is missing ${directive} ${source}: ${page}`);
      }
    }
  }

  const policySources = [...csp.values()].flat();
  for (const blockedSource of ["'unsafe-inline'", "'unsafe-eval'"]) {
    if (policySources.includes(blockedSource)) {
      throw new Error(`Built page CSP contains ${blockedSource}: ${page}`);
    }
  }

  for (const match of html.matchAll(/<script\b([^>]*)>([\s\S]*?)<\/script>/gi)) {
    if (!/\bsrc=/i.test(match[1]) && !csp.get('script-src')?.includes(contentHash(match[2]))) {
      throw new Error(`Built page CSP does not authorize an inline script: ${page}`);
    }
  }

  for (const match of html.matchAll(/<style\b[^>]*>([\s\S]*?)<\/style>/gi)) {
    if (!csp.get('style-src')?.includes(contentHash(match[1]))) {
      throw new Error(`Built page CSP does not authorize an inline style: ${page}`);
    }
  }

  if (/\sstyle="/i.test(html)) {
    throw new Error(`Built page contains a style attribute that the site CSP blocks: ${page}`);
  }

  for (const match of html.matchAll(/(?:href|src)="([^"]+)"/g)) {
    const reference = match[1];
    if (/^(?:https?:|mailto:|tel:|data:)/.test(reference)) {
      continue;
    }

    const [targetPath, fragment] = reference.split('#', 2);
    const target = targetPath === ''
      ? path
      : targetPath.startsWith('/')
        ? builtTarget(targetPath)
        : resolve(dirname(path), targetPath);

    if (!existsSync(target)) {
      throw new Error(`Broken local reference in ${page}: ${reference}`);
    }

    if (fragment && target.endsWith('.html')) {
      const targetHtml = readFileSync(target, 'utf8');
      if (!targetHtml.includes(`id="${fragment}"`)) {
        throw new Error(`Broken local fragment in ${page}: ${reference}`);
      }
    }
  }
}

const privacyHtml = readFileSync(resolve(distDirectory, 'privacy/index.html'), 'utf8');
for (const statement of ['no advertising', 'no analytics', 'no account']) {
  if (!privacyHtml.toLowerCase().includes(statement)) {
    throw new Error(`Privacy page is missing the required statement: ${statement}`);
  }
}

const indexHtml = readFileSync(resolve(distDirectory, 'index.html'), 'utf8');
const heroImageTag = indexHtml.match(
  /<img\b[^>]*alt="A woman gently petting her dog at home"[^>]*>/,
)?.[0];

if (!heroImageTag) {
  throw new Error('Built home page is missing the hero image');
}
for (const attribute of ['srcset=', 'loading="eager"', 'fetchpriority="high"']) {
  if (!heroImageTag.includes(attribute)) {
    throw new Error(`Built hero image is missing ${attribute}`);
  }
}

if (indexHtml.includes('/brand/design-tokens.css')) {
  throw new Error('Built home page loads the design tokens stylesheet twice');
}
