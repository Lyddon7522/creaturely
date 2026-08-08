import { copyFileSync, cpSync, mkdirSync, rmSync } from 'node:fs';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const scriptDirectory = dirname(fileURLToPath(import.meta.url));
const siteDirectory = resolve(scriptDirectory, '..');
const repositoryDirectory = resolve(siteDirectory, '..');
const brandDirectory = resolve(repositoryDirectory, 'assets', 'brand');
const publicBrandDirectory = resolve(siteDirectory, 'public', 'brand');

mkdirSync(resolve(siteDirectory, 'src', 'styles'), { recursive: true });
mkdirSync(resolve(siteDirectory, 'public'), { recursive: true });
rmSync(publicBrandDirectory, { recursive: true, force: true });
mkdirSync(publicBrandDirectory, { recursive: true });

copyFileSync(
  resolve(brandDirectory, 'design-tokens.css'),
  resolve(siteDirectory, 'src', 'styles', 'brand-tokens.generated.css'),
);
copyFileSync(
  resolve(brandDirectory, 'design-tokens.css'),
  resolve(publicBrandDirectory, 'design-tokens.css'),
);
cpSync(resolve(brandDirectory, 'logos'), resolve(publicBrandDirectory, 'logos'), {
  recursive: true,
});
