export type { ConfigDocumentJson, FormControlKind, FormRowJson } from './types.js';

/**
 * Host apps fetch merged JSON from `uniconfig dump` or WASM uniconfig-core later.
 * Next.js: import from `@dev-centr/configui-web/solid` inside a client component.
 */
export const PACKAGE = '@dev-centr/configui-web';
