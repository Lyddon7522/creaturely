import assert from 'node:assert/strict';
import { readFileSync, readdirSync, statSync } from 'node:fs';
import { dirname, extname, resolve } from 'node:path';
import test from 'node:test';
import { fileURLToPath } from 'node:url';

const testDirectory = dirname(fileURLToPath(import.meta.url));
const siteDirectory = resolve(testDirectory, '..');

function sourceFiles(directory) {
  return readdirSync(directory).flatMap((entry) => {
    const path = resolve(directory, entry);
    if (statSync(path).isDirectory()) {
      return sourceFiles(path);
    }
    return ['.astro', '.css', '.ts'].includes(extname(path)) ? [path] : [];
  });
}

test('published copy contains no em dashes', () => {
  for (const path of sourceFiles(resolve(siteDirectory, 'src'))) {
    assert.equal(readFileSync(path, 'utf8').includes('—'), false, path);
  }
});

test('app-store support routes are present', () => {
  for (const page of ['privacy.astro', 'support.astro', 'terms.astro']) {
    assert.equal(statSync(resolve(siteDirectory, 'src', 'pages', page)).isFile(), true);
  }
});

test('the site does not load remote image or script assets', () => {
  for (const path of sourceFiles(resolve(siteDirectory, 'src'))) {
    const source = readFileSync(path, 'utf8');
    assert.doesNotMatch(source, /(?:src|srcset)=["']https?:\/\//, path);
    assert.doesNotMatch(source, /<script[^>]+src=["']https?:\/\//, path);
  }
});

test('static hosting normalizes page and file URLs independently', () => {
  const config = JSON.parse(
    readFileSync(resolve(siteDirectory, 'staticwebapp.config.json'), 'utf8'),
  );

  assert.equal(config.trailingSlash, 'auto');
  assert.equal(
    readFileSync(resolve(siteDirectory, 'public', 'robots.txt'), 'utf8').includes(
      'sitemap-index.xml/',
    ),
    false,
  );
});
