# Creaturely Brand Guidelines v1.0

## Quick reference

- **Brand name:** Creaturely
- **Tagline:** Know their normal.
- **Primary color:** Vital Teal `#087E78`
- **Accent color:** Heart Coral `#F26B5B`
- **Primary text:** Soft Ink `#19302F`
- **Product type:** Native platform system fonts
- **Voice:** Steady, caring, observant
- **Core idea:** Calm care, made visible.

## 1. Brand foundation

Creaturely helps people notice meaningful changes between veterinary visits.
The identity balances two needs: it feels warm enough for a beloved companion
and precise enough for health information.

### Brand promise

Make everyday pet observations easier to understand, remember, and share.

### Brand Personality

| Trait | We are | We are not |
| --- | --- | --- |
| **Steady** | Calm, clear, dependable | Alarmist or clinical-sounding |
| **Caring** | Warm and respectful | Cute at the expense of clarity |
| **Observant** | Specific, useful, attentive | Judgmental or overconfident |

### Messaging

- **Primary line:** Know their normal.
- **Supporting line:** Small observations can tell a bigger story.
- **Value statement:** Track everyday signs, spot changes, and keep a clearer
  health history for every pet.

Do not imply that the app diagnoses, treats, or replaces veterinary care.

## 2. Logo system

The mark combines three ideas in one compact shape:

- The **heart** represents care and continuity.
- The **paw** makes the subject immediately recognizable.
- The **pulse** signals observation and health tracking.

### Approved variants

| Variant | File | Use |
| --- | --- | --- |
| Horizontal primary | `assets/brand/logos/creaturely-logo-horizontal-primary.svg` | Default headers, documents, and marketing |
| Horizontal reversed | `assets/brand/logos/creaturely-logo-horizontal-reversed.svg` | Deep Teal and dark-mode surfaces |
| Stacked primary | `assets/brand/logos/creaturely-logo-stacked-primary.svg` | Square placements and covers |
| Primary mark | `assets/brand/logos/creaturely-mark-primary.svg` | Compact UI and light-background avatars |
| Reversed mark | `assets/brand/logos/creaturely-mark-reversed.svg` | Compact dark-background placement |
| Monochrome dark | `assets/brand/logos/creaturely-logo-mono-dark.svg` | One-color output |
| App icon master | `assets/brand/logos/creaturely-app-icon.svg` | iOS, Android, and web launcher exports |

### Clear space

Use the height of the central paw pad as the minimum clear space on every side.
Nothing else should enter that area.

### Minimum size

- Horizontal logo: `120 px` wide digitally or `35 mm` in print.
- Stacked logo: `80 px` wide digitally.
- Mark: `24 px` digitally or `10 mm` in print.
- Use the app-icon artwork, not the small mark, for launcher icons.

### Backgrounds

- Use the primary logo on White, Cloud Canvas, or Soft Mint.
- Use the reversed logo on Deep Teal or the dark theme background.
- On photography, place the logo on a solid brand-color panel when the image
  does not provide a calm, high-contrast area.

### Do not

- Stretch, rotate, crop, outline, or rearrange the logo.
- Add shadows, gradients, glows, or transparency.
- Recolor individual elements outside the approved variants.
- Put the detailed wordmark below its minimum size.
- Use Heart Coral as the main logo color.

## 3. Color palette

### Primary Colors

| Name | Hex | RGB | Usage |
| --- | --- | --- | --- |
| Vital Teal | `#087E78` | `rgb(8, 126, 120)` | Primary actions, selected navigation, key data |
| Deep Teal | `#075D59` | `rgb(7, 93, 89)` | Dark emphasis, reversed-logo fields |
| Fresh Mint | `#77D6CE` | `rgb(119, 214, 206)` | Dark-mode primary, highlights |
| Soft Mint | `#CFEDEA` | `rgb(207, 237, 234)` | Selected surfaces, gentle callouts |

### Secondary Colors

| Name | Hex | RGB | Usage |
| --- | --- | --- | --- |
| Heart Coral | `#F26B5B` | `rgb(242, 107, 91)` | Sparse warmth, badges, moments of attention |
| Blush | `#FFF1ED` | `rgb(255, 241, 237)` | Coral container and gentle emphasis |

Heart Coral is an accent, not a substitute for semantic error red. Keep it to
roughly 5–10% of a screen or composition.

### Neutrals

| Name | Hex | RGB | Usage |
| --- | --- | --- | --- |
| Soft Ink | `#19302F` | `rgb(25, 48, 47)` | Primary text and dark monochrome logo |
| Quiet Slate | `#5D706F` | `rgb(93, 112, 111)` | Secondary text |
| Mist Border | `#D7E3E1` | `rgb(215, 227, 225)` | Borders and dividers |
| Cloud Canvas | `#F7FBFA` | `rgb(247, 251, 250)` | App background |
| White | `#FFFFFF` | `rgb(255, 255, 255)` | Cards and clean surfaces |

### Semantic colors

| Meaning | Hex | Use |
| --- | --- | --- |
| Success | `#237A4B` | Confirmed healthy completion or saved state |
| Warning | `#8A5A00` | Attention without immediate danger |
| Error | `#B64145` | Failed action or critical validation |
| Information | `#2E6FA3` | Neutral guidance and educational content |

Always pair semantic colors with text or an icon. Color must never carry the
meaning by itself.

### Dark theme

| Role | Hex |
| --- | --- |
| Background | `#102523` |
| Surface | `#17312F` |
| Primary | `#77D6CE` |
| On primary | `#0B2D2A` |
| Accent | `#FF9B8B` |
| Primary text | `#EAF4F2` |
| Secondary text | `#B8CAC7` |
| Border | `#607A76` |

### Accessibility

Verified reference combinations:

| Foreground / background | Contrast | Result |
| --- | ---: | --- |
| Vital Teal / White | `4.92:1` | WCAG AA normal text |
| Deep Teal / White | `7.72:1` | WCAG AAA normal text |
| Soft Ink / Cloud Canvas | `13.38:1` | WCAG AAA |
| Quiet Slate / Cloud Canvas | `5.02:1` | WCAG AA normal text |
| Soft Ink / Heart Coral | `4.67:1` | WCAG AA normal text |
| Fresh Mint / dark on-primary | `8.64:1` | WCAG AAA |

Do not set white normal-sized text on Heart Coral; that combination is only
`2.99:1`. Use Soft Ink on Heart Coral instead.

## 4. Typography

The app intentionally uses native platform typography for performance,
legibility, and a familiar health-product feel.

### Font Stack

```css
--font-heading: "SF Pro Rounded", "Arial Rounded MT Bold", sans-serif;
--font-body: "SF Pro Text", "Segoe UI", sans-serif;
--font-mono: "SFMono-Regular", Menlo, monospace;
```

- Use the rounded display stack for the wordmark and short, expressive
  marketing headlines.
- Use the platform UI stack for every in-product heading, label, and body line.
- Do not use thin weights below `400`.

### Product type scale

| Style | Size | Weight | Line height | Use |
| --- | ---: | ---: | ---: | --- |
| Display | 40 px | 700 | 1.15 | Empty states and marketing moments |
| Heading 1 | 32 px | 700 | 1.2 | Page title |
| Heading 2 | 24 px | 700 | 1.25 | Section title |
| Heading 3 | 20 px | 600 | 1.3 | Card title |
| Body | 16 px | 400 | 1.5 | Default reading |
| Label | 14 px | 600 | 1.4 | Controls and navigation |
| Caption | 12 px | 500 | 1.4 | Metadata only |

Keep body copy at `16 px` whenever space allows. Use sentence case in the app;
reserve spaced uppercase for small brand labels such as the tagline.

## 5. UI expression

### Shape

- Small radius: `8 px`
- Standard control/card radius: `14 px`
- Feature panel radius: `24 px`
- Pills and status chips: fully rounded

Use rounded geometry to echo the mark, but keep charts and health data crisp.

### Iconography

- Use simple outlined icons on a 24 px grid.
- Keep a consistent 2 px visual stroke.
- Pair state icons with labels for health meaning.
- Use the filled heart/paw mark only as brand identification, not as a generic
  health status icon.

### Photography

- Prefer pets in natural daylight and familiar environments.
- Show attentive, honest moments rather than staged costumes or exaggerated
  expressions.
- Preserve natural coat and skin colors.
- Leave quiet negative space for UI or messaging.
- Avoid imagery that appears distressing unless the context clearly requires it.

## 6. Voice and product copy

### Writing principles

- Lead with the observation or action.
- Use plain language and short sentences.
- Be specific about what the app knows.
- Give calm next steps when something needs attention.

### Examples

| Context | Preferred copy |
| --- | --- |
| Empty history | “No observations yet. Add one when you notice a change.” |
| Save success | “Observation saved.” |
| Reminder | “Time for Jude’s evening check-in.” |
| Error | “We couldn’t save that observation. Your entries are still here.” |
| Safety note | “If you’re worried about your pet, contact a veterinarian.” |

Avoid language such as “diagnosed,” “all clear,” “definitely healthy,” or
“emergency detected” unless the app has an appropriately regulated and
validated basis for making that claim.

### Forbidden Phrases

- “diagnosed”
- “all clear”
- “definitely healthy”
- “emergency detected”

## 7. Asset references

- Visual overview: `assets/brand/brand-board.svg`
- Platform-neutral tokens: `assets/brand/design-tokens.json`
- Web tokens: `assets/brand/design-tokens.css`

SVG is the source of truth. Export PNGs from the SVG master at the exact target
size; do not repeatedly resize a raster export.
