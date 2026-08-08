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

for (const page of expectedPages) {
  const path = resolve(distDirectory, page);
  if (!existsSync(path)) {
    throw new Error(`Expected built page is missing: ${page}`);
  }

  const html = readFileSync(path, 'utf8');
  if (html.includes('—')) {
    throw new Error(`Built page contains an em dash: ${page}`);
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
