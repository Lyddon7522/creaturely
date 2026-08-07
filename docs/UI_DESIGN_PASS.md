# Creaturely UI design pass

## Direction

Creaturely should feel calm, warm, and immediately useful. The visual system
already has the right ingredients: native typography, generous spacing, Vital
Teal for action, Heart Coral for sparse warmth, and restrained surfaces. This
pass changes hierarchy and interaction more than branding.

The target experience is:

- pet-first, with the selected animal always obvious;
- today-first, so due care is easier to act on than configuration;
- minimal, but never so flat that tappable content looks static;
- data-readable, with human units and no hidden horizontal tables on phones;
- progressively disclosed, with creation and advanced editing behind clear
  browse/manage destinations.

## Reference takeaways

- **Wise:** make the important state obvious, then place the few common actions
  directly beside it. Secondary setup belongs deeper in the flow.
- **How We Feel:** use color to make categories and states recognizable, while
  guiding one focused check-in at a time.
- **Hinge:** attach an action to the exact content it affects. For Creaturely,
  dose actions belong with the dose and medication rows open that medication.
- **Jupiter Mobile:** lead with the selected account/pet, keep switching easy,
  and provide a unified manage view instead of several creation shortcuts.
- **Elevate:** put today's recommended activity first and make it effortless to
  resume. Creaturely should do this for scheduled care without gamifying health.
- **Grit:** clear completion states and detailed history are useful; streaks and
  guilt-oriented mechanics are not appropriate for pet medication adherence.
- **Notion:** quiet typography and block hierarchy work well, but mobile flows
  should prioritize retrieval and quick capture instead of exposing every
  configuration option at once.

Reference pages reviewed:

- [Grit: Daily Habit Tracker UI breakdown](https://screensdesign.com/showcase/grit-daily-habit-tracker)
- [Wise account navigation redesign](https://wise.com/help/articles/645Ve1Ah1Psi0srHGfKYmm/your-wise-account-has-a-new-look)
- [How We Feel](https://howwefeel.org/)
- [How Hinge works](https://help.hinge.co/hc/en-us/articles/26845979318803-What-is-Hinge)
- [Jupiter Mobile Wallet](https://play.google.com/store/apps/details?id=ag.jup.jupiter.android)
- [Elevate Today tab](https://support.elevateapp.com/hc/en-us/articles/4402924805275-How-do-I-use-the-app)
- [Notion mobile](https://www.notion.com/mobile)
- [Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines)
- [Material Design 3](https://m3.material.io/)

## Screen decisions

### Animal home

1. Compact pet identity and keep edit/export reachable.
2. Quick shortcuts reflect frequent intent:
   - Count breaths — start the timer.
   - Log weight — open a preselected weigh-in.
   - Medications — review and record due doses.
   - Documents — browse saved documents, with add available there.
3. Make every current-care row navigable. Breathing and weight open their trend;
   active medications open management; due doses open today's schedule.
4. Keep the animal switcher as the primary way to move between pets and avoid
   over-emphasizing a duplicate animal list.

#### Visual expression

- Pair Wise and Notion's quiet structure with the controlled color and
  illustrated character seen in How We Feel and Elevate.
- Treat the selected animal as the feature moment: a soft teal-to-coral field,
  an illustrated species avatar when no photo exists, and no competing chrome.
- Give shortcuts distinct, low-contrast color fields and oversized icon
  watermarks so they scan as different actions without becoming noisy.
- Show non-selected pets as compact, tappable portrait orbs. Do not repeat the
  selected pet or use full-width cards for one line of identity.
- Use solid Font Awesome Free species glyphs rather than initials, emoji, or
  hand-scaled paths. Fall back to a paw where the free set has no honest match.

### Trends

- Keep charts and their compact descriptive summaries.
- Replace the horizontally hidden mobile data table with stacked measurement
  rows. Use `Recorded as` instead of `Canonical/raw value`.
- Show respiratory duration in seconds, not milliseconds.
- Reconstruct a weight's entered unit for `Recorded as` instead of exposing
  canonical kilograms.
- Treat historical medication outcomes as Given, Skipped, or Missed. Pending
  internal ledger entries do not belong in the outcome summary.
- Medication rows are tappable and open a focused detail/history screen.

### Settings and recovery

- Use `Notifications`, not `Local notifications`.
- Explain retention in user language; SHA-256 deduplication belongs in the
  backup-format documentation, not the settings UI.
- Automatic recovery is at most daily. `Back up now` remains available for an
  immediate manual snapshot. Retention remains latest + 7 daily + 4 weekly +
  6 monthly recovery points.

### Pet export

- Keep export in Settings for discoverability.
- Add a direct Export action to the selected animal and open a pet-focused
  export screen with that animal already selected.

## Guardrails

- Preserve Creaturely's established brand tokens and native type.
- Keep all tap targets at least 48 dp.
- Use labels and icons together for health states; never rely on color alone.
- Respect Dynamic Type, reduced motion, narrow phones, landscape, and tablets.
- Do not add diagnostic language, competitive adherence, or punitive streaks.
