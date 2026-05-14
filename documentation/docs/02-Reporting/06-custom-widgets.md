---
title: Custom SQL view widgets
---

Custom SQL view widgets let a hospital surface local SQL-view data inside a
Renalware dashboard or summary page without adding a Renalware model for that
data.

They are intended for compact, read-only tables. They are deliberately simpler
than reports: there is no filtering, charting, CSV export or pagination. If users
need to explore a larger data set, create a normal report instead.

## How it works

A custom widget has three parts:

1. A SQL view in Postgres.
2. A `renalware.system_view_metadata` row with `category = 'widget'`.
3. A named widget slot in a Renalware view, for example `hd_mdm:middle`.

At render time Renalware finds all widget metadata rows whose `widget_options`
include the slot name, queries each SQL view, and renders the result in an
`<article>` table.

## Create the SQL view

Create the SQL view in the hospital-specific schema where possible. The view can
be global, or it can be scoped to a patient.

For a patient-scoped widget, the SQL view must return a patient id column. The
column name is configurable, but `patient_id` is recommended.

Example:

```sql
CREATE OR REPLACE VIEW renalware_kch.ukm_adequacy_widget AS
SELECT
  patient_id,
  performed_on,
  test_type
FROM renalware_kch.ukm_adequacy_results;
```

For local development, the test view `renalware.test_view` can be used if it
exists. It returns:

```text
patient_id, performed_on, test_type
```

## Add widget metadata

Add a row to `renalware.system_view_metadata`.

```sql
INSERT INTO renalware.system_view_metadata
(
  schema_name,
  view_name,
  category,
  title,
  columns,
  widget_options,
  position,
  created_at,
  updated_at
)
VALUES
(
  'renalware_kch',
  'ukm_adequacy_widget',
  'widget',
  'UKM adequacy',
  '[
    { "code": "patient_id", "hidden": true },
    { "code": "performed_on", "name": "Date", "width": "date" },
    { "code": "test_type", "name": "Type" }
  ]',
  '{
    "slots": ["hd_mdm:middle"],
    "max_rows": 5,
    "patient_id_column": "patient_id",
    "order_by": "performed_on",
    "order_direction": "desc",
    "empty_state": "No UKM adequacy data"
  }',
  1,
  current_timestamp,
  current_timestamp
);
```

## Widget options

`widget_options` is JSON stored on the metadata row.

| Option | Required | Description |
| --- | --- | --- |
| `slots` | Yes | Array of named page slots where the widget should render. |
| `max_rows` | No | Maximum rows to display. Defaults to `5`. Maximum is `100`. |
| `patient_id_column` | No | Column used to scope rows to the current patient. Omit for global widgets. |
| `order_by` | No | SQL view column used for ordering. |
| `order_direction` | No | `asc` or `desc`. Defaults to `desc`. |
| `empty_state` | No | Text shown when the widget has no rows. |

If `patient_id_column` is present, Renalware will only show rows for the patient
passed to the widget slot. If the slot is rendered without a patient, Renalware
shows the empty state rather than returning unscoped rows.

## Column definitions

Widgets reuse the existing `system_view_metadata.columns` format used by reports.

Useful column options are:

| Option | Description |
| --- | --- |
| `code` | SQL view column name. |
| `name` | Display label. Falls back to a humanized column name. |
| `hidden` | Hide the column from the widget. Useful for `patient_id`. |
| `width` | Optional width hint, such as `tiny`, `small`, `medium`, `large`, `date`, `datetime`, `nhs_number`, `hospital_numbers` or `patient_name`. |
| `truncate` | Whether to truncate long cell content. |

Columns not listed in metadata are still displayed unless hidden. Put columns in
the metadata array to control the display order.

## Add a slot to a page

Render a slot from any Slim view:

```slim
= sql_view_widgets_for("hd_mdm:middle", patient: mdm.patient)
```

For a global widget, omit the patient:

```slim
= sql_view_widgets_for("dashboard:admin")
```

The slot name is just a convention. Use names that identify the page and the
region, for example:

```text
hd_mdm:middle
hd_dashboard:right_column
patient_summary:left_column
```

## Example using the development test view

If `renalware.test_view` exists in the development database, this metadata row
will render it in the HD MDM middle slot:

```sql
INSERT INTO renalware.system_view_metadata
(
  schema_name,
  view_name,
  category,
  title,
  columns,
  widget_options,
  position,
  created_at,
  updated_at
)
VALUES
(
  'renalware',
  'test_view',
  'widget',
  'Test view',
  '[
    { "code": "patient_id", "hidden": true },
    { "code": "performed_on", "name": "Date", "width": "date" },
    { "code": "test_type", "name": "Type" }
  ]',
  '{
    "slots": ["hd_mdm:middle"],
    "max_rows": 5,
    "patient_id_column": "patient_id",
    "order_by": "performed_on",
    "order_direction": "desc",
    "empty_state": "No test view data"
  }',
  1,
  current_timestamp,
  current_timestamp
);
```

## Limitations

- Widgets are read-only.
- Widgets do not paginate.
- Widgets do not support report filters.
- Widgets do not currently link to a full report automatically.
- SQL view, order and patient-scope columns must be real columns in the view.
- Patient-scoped widgets depend on the SQL view returning the configured patient
  id column.

