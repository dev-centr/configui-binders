# configui-binders — agent notes

- Monorepo of toolkit binders for UniConfig `FormRow` / `flattenFormRows` (engine: `uniconfig-core`).
- Primary desktop target: `configui-dui` (dui/dew). ConfigUI app still uses `configui-dlangui` until dui binder lands.
- Web: `@dev-centr/configui-web` — TS types + Solid; Next.js uses client wrapper importing `/solid`.
- Qt/GTK/Avalonia: stubs only.
- Do not add intra-file fork support here — sidecars only until connectome-fs.
