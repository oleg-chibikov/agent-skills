# The focused rounds: security, speed, accessibility

Each round reads the same change again with one question in mind. They run
after the second round [architecture-pass.md](architecture-pass.md), in the
order below, each opened by one line naming it.

## Which rounds run

- **Security** MUST run on every review.
- **Speed** MUST run when the change holds code that runs. Docs, copy and
  comments alone skip it.
- **Accessibility** MUST run when the change touches what a person sees or
  uses on screen: markup, components, styles, UI text.
- **A skipped round** gets one line saying why.

## Security

Follow each input from where it enters to where it lands.

- Can it reach HTML, a query, a shell, a file path or a redirect unescaped?
- Does each new endpoint, action or job check who calls it and what they may
  touch?
- Does a secret, a token or personal data end up in code, logs, a URL, an error
  or the browser bundle?
- Did sessions, cookies, CORS or CSRF settings change, and do they still hold?
- A new dependency: is it maintained, with no known hole, and no more access
  than it needs?

## Speed

- **Repeated work**: a request or a query per item in a loop, the same sum
  worked out on every render.
- **No upper bound**: a whole table loaded at once, no paging, a cache that only
  grows.
- **Browser**: a re-render on every keystroke, a heavy import in the first
  bundle, an image with no size that shifts the layout.
- **Server**: a new query with no index, a lock held over a network call, a slow
  call on the hot path.

A speed finding MUST name the size where it starts to hurt: "slow past 1,000
rows". A guess is marked as one.

## Accessibility

Check against WCAG 2.2 AA.

- **Keyboard**: every new control is reached with Tab and works with Enter or
  Space. Focus lands somewhere sensible when a dialog opens and closes.
- **Screen reader**: every control has a name, an icon button a label, an image
  alt text. A change of state is announced.
- **Markup**: a clickable `div` where a `button` belongs, a skipped heading
  level, a field with no label.
- **Sight**: text contrast under 4.5:1, meaning carried by colour alone, a
  layout that breaks at 200% zoom.
- **Motion**: animation that ignores `prefers-reduced-motion`.

## What comes out

- Each round takes the shape set in "What comes out" of
  [architecture-pass.md](architecture-pass.md), numbers carried on.
- A finding an earlier pass already has MUST NOT come back.
- A round with no findings says so in one line, naming what it checked.
