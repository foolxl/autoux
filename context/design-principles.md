# Design Principles

> Customize this file for your project. These principles guide the Brand Alignment judge persona when evaluating your UI. Delete the examples below and replace with your own.

## Visual Hierarchy

- **Primary actions should be immediately obvious.** Use size, contrast, and positioning to make the most important element on each page unmissable.
- **Progressive disclosure.** Show essential information first. Details on demand.
- **F-pattern for content pages, Z-pattern for landing pages.** Design the visual flow to match how users naturally scan.

## Spacing & Layout

- **Use an 8px spacing grid.** All spacing values should be multiples of 8: 8, 16, 24, 32, 48, 64, 96.
- **Consistent vertical rhythm.** Sections should have equal spacing between them.
- **Generous whitespace.** When in doubt, add more space. Cramped layouts feel cheap.

## Typography

- **Clear size hierarchy.** At minimum: heading (24-32px), subheading (18-20px), body (14-16px), caption (12px).
- **Limit font families.** One font family for body, optionally one for headings. Never more than two.
- **Line height of 1.5 for body text.** Ensures readability.

## Color

- **Define a palette and stick to it.** Primary, secondary, accent, neutral, success, warning, error.
- **Use color intentionally.** Every color should serve a purpose — don't add color for decoration.
- **Ensure contrast.** All text must meet WCAG AA contrast ratios (4.5:1 normal, 3:1 large).

## Components

- **Consistent border-radius.** Pick one value (e.g., 8px) and use it everywhere.
- **Consistent shadow system.** Define 2-3 elevation levels and reuse them.
- **Interactive elements need states.** Default, hover, active, focus, disabled.

## Responsive Design

- **Mobile-first thinking.** Design for the smallest screen first, enhance for larger.
- **Touch targets minimum 44x44px** on mobile.
- **Content should reflow, not shrink.** Text should never be smaller on mobile.

## Accessibility

- **Semantic HTML first.** Use proper heading levels, landmarks, and form labels.
- **Keyboard navigable.** Every interactive element reachable via Tab.
- **Focus states visible.** Never remove focus outlines without replacing them.
