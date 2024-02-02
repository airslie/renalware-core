---
title: Adding filters
---

You can filter by any column in your SQL view.

To add filters you update the `filters` column in the `system_view_metadata` column.

## Dropdown filters

For example if you view has a column 'age' and you want a dropdown of distinct values so
you can choose only patient with an age say of 39, you can update `system_view_metadata.filters` with

```
[{"code": "age", "type": 0}]
```

:::note
Filter type 0 = a drop downlist of all possible options
Filter type 1 = a searchable text input
:::

![Filter example](/img/report-filters.jpg)


## Text search filters

If you want to allow searching on a specific column in your report - eg patient_name in ou case -
you can add another filter to `system_view_metadata.filters` of type 1

```
[
  {"code": "patient_name", "type": 1},
  {"code": "age", "type": 0},
]
```
![Filter example](/img/report-multiple-filters.jpg)
