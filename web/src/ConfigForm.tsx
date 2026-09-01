import { For, Show, type Component } from 'solid-js';
import type { FormRowJson } from './types.js';

export interface ConfigFormProps {
  rows: FormRowJson[];
  onChange?: (path: string, value: string, included: boolean) => void;
}

/** Minimal Solid binder — expand with real controls per FormControlKind. */
export const ConfigForm: Component<ConfigFormProps> = (props) => (
  <div class="configui-form">
    <For each={props.rows}>
      {(row) => (
        <Show
          when={row.kind !== 'sectionHeader'}
          fallback={
            <h3 style={{ 'margin-left': `${row.depth * 0.5}rem` }}>{row.label}</h3>
          }
        >
          <label style={{ display: 'block', 'margin-left': `${row.depth * 0.5}rem` }}>
            {row.showIncludeToggle && <input type="checkbox" title="include" />}{' '}
            {row.label}
            <Show when={row.kind === 'boolean'}>
              <input
                type="checkbox"
                checked={row.value === 'true'}
                onChange={(e) =>
                  props.onChange?.(row.path, e.currentTarget.checked ? 'true' : 'false', true)
                }
              />
            </Show>
            <Show when={row.kind === 'choice' && row.enumValues}>
              <select
                onChange={(e) => props.onChange?.(row.path, e.currentTarget.value, true)}
              >
                <For each={row.enumValues!}>{(v) => <option value={v}>{v}</option>}</For>
              </select>
            </Show>
            <Show when={row.kind === 'text'}>
              <input
                type="text"
                value={row.value ?? ''}
                onInput={(e) => props.onChange?.(row.path, e.currentTarget.value, true)}
              />
            </Show>
          </label>
        </Show>
      )}
    </For>
  </div>
);
