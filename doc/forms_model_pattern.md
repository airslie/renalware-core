# Renalware Form Model Pattern

This is developer guidance for building new or substantially rewritten Renalware
HTML forms. The architectural decision is recorded in
[ADR-0001](../docs/adr/ADR-0001-form-with-builder.md).

## Goals

- Keep rendered HTML explicit and easy to reason about.
- Avoid wrapper DSL magic and hidden side effects.
- Use Tailwind-backed classes with a small, stable surface area.
- Migrate one form at a time with low risk.

## Core Pattern

- Use `form_with` with `Renalware::FormBuilders::Horizontal`.
- Keep builder methods small and predictable.
- Use explicit template markup for unusual cases.
- Keep legacy `simple_form` forms working, but do not introduce new usage.

Example:

```slim
= form_with model: attachment,
            builder: Renalware::FormBuilders::Horizontal,
            html: { class: "rw-form" } do |f|
  = f.error_summary
  = f.date_row :document_date
  = f.text_row :name
  = f.text_area_row :description

  = f.actions_row do
    = link_to t("btn.cancel"), patient_attachments_path(attachment.patient), class: "btn btn-secondary"
    = f.submit nil, class: "btn btn-primary"
```

## Builder API

- `error_summary`
- `field_row`
- `text_row`
- `date_row`
- `text_area_row`
- `select_row`
- `file_row`
- `actions_row`

Field sizing is controlled via a semantic `size:` option:

- `:xs`
- `:sm`
- `:md`
- `:lg`
- `:full`
- `:date` (used by default in `date_row`)

Example:

```slim
= f.date_row :document_date
= f.text_row :name, size: :sm
```

If a form needs behaviour that does not fit these methods cleanly, prefer
explicit view markup first.

## CSS Contract

These classes are defined in
`app/assets/stylesheets/components/forms.css`:

- `.rw-form`
- `.rw-field-row`
- `.rw-label`
- `.rw-label__text`
- `.rw-control`
- `.rw-input`
- `.rw-hint`
- `.rw-error`
- `.rw-actions`
- `.rw-error-summary`

## Migration Guidelines

- Do not alter global SimpleForm behaviour as part of a form migration.
- Convert one form end-to-end before attempting broader reuse.
- Validate parity for submission flow, errors, and JavaScript data attributes.
- Capture lessons learned before migrating another form pattern.
