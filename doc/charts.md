# Charts

## Pathology Charts

2 types of charts can be create:
- a chart with a single series representing one single observation description (aka OBX) for a
  patient over time. These are useful when hovering/clicking on a OBX code to see a chart.
- a chart with multiple series, representing a number of observation description results for a patient over time
  and defined in code as a 'Pathology::Charts::Chart' model with many observation descriptions through Pathology::Charts::Series.
  Charts are useful for defining preset charts to appear in certain places in the UI. An options]
  hash in the chart allows more specific customisation.

An observation description has the following chart-related attributes via a Chartable mixin:
- `y_axis_label` - the measurement_unit.name if one is pressent eg mL
- `y_axis_type` - eg logarithmic or linear
- `title` - the code or name of the observation description
- `colour` - optional line colour
- `sql_function_name` - if present, the obs desc is 'virtual' and will never have corresponding
  results in pathology_observations; instead the function will return virtual/calculated/derived
  results eg the product of two non-virtual obs desc.

### Dynamic charting

It is possible to define a UI where > obx can be added to an empty chart.
Things to bear in mind
- axis compatibility - the unit of measurement should be the same for any 2 series associated with
  the same axis
- the RH y axis y2 can be used for a series having a measurement unit incompatible with y1.
