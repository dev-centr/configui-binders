# @dev-centr/configui-web

TypeScript + **Solid** components for ConfigUI on the web.

## Why one web package

- **TypeScript** types are the interchange layer (`FormRowJson`).
- **Solid** components for reactive forms (Vite, Astro islands, etc.).
- **Next.js** — import `@dev-centr/configui-web/solid` from a `'use client'` wrapper; no separate Next package.

Plain JS apps can use the types + copy the Solid component pattern, or wait for a thin `preact` adapter.

## Data source

Today: `uniconfig dump FILE` JSON + rows produced by your app server. Future: WASM `uniconfig-core`.
