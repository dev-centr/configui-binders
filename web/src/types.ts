/** UniConfig merged-tree field kinds — mirrors uniconfig.core.form_model.FormControlKind */
export type FormControlKind = 'sectionHeader' | 'boolean' | 'choice' | 'text';

export interface FormRowJson {
  kind: FormControlKind;
  path: string;
  label: string;
  depth: number;
  showIncludeToggle: boolean;
  description?: string;
  enumValues?: string[];
  value?: string;
  schemaType?: string;
}

export interface ConfigDocumentJson {
  path: string;
  format: string;
  rows: FormRowJson[];
}
