# Factory Girl Style Guide

* factories should be as simple as possible
* use these Factory Girl methods in order of preference:
  * `attributes_for`
  * `build`
  * `build_stub`
  * `create` (as a final resort)
* in integration request specs use `attributes_for`; e.g. `post event_types_path, event_type: { attributes_for(:event_type) }`
* consider `after(:create)` as a smell
* use traits only to communicate `roles` an object can play and `states` an object can be
* factories can only create `Description` or value objects (aka look-up tables) within the object graph, not `Entity`, `Role`, or `Event` objects
* exception to this would be a user for the accountable fields i.e. `created_by`, `updated_by`.
* use factories only for unit tests, not for acceptance tests

## Rules under consideration

* never use `after(:X)`
* if a _service_ method exist for adding an associated object, you must use the service method, not create the associated object using a factory. e.g. `Registration#add_status`
