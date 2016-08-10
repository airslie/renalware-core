# Application Architecture and Testing Guide

Renalware 2.0 is a monolithic application carefully partitioned into vertical slices and horizontal layers.

Please note, the application does not comply 100% to the architecture below. The application was started before these ideas were introduced to the project and some of these ideas have evolved over time.

## Vertical Slices

Vertical slices are implemented using Ruby modules. We are careful to avoid circular dependencies (e.g. the `Letters` module knows about the `Patients` module, but the `Patients` module does not know about the `Letters` module `Letters -> Patients`). This allows us to grow the application in a sustainable manner, by adding or removing modules as required. It avoids a "God object" (an object that attract the majority of responsibilities in the system) by keeping related behavior together - each module has it's own Patient model that reflects its role in that module only (e.g. [`Letter::Patient`](https://github.com/airslie/renalwarev2/blob/master/app/models/renalware/letters/patient.rb)).

## Horizontal Layers

Where appropriate, we use the "Rails-way" (a basic MVC stack with Mailers, Helpers etc). This is approach is followed for the standard CRUD features that don't require complex business rules such as  managing look-up tables. In addition to the basic stack, we use Policy objects to manage Authorization (Pundit).

When business rules or the application interaction become more complex, we will selectively add additional types of objects. These archetypes are described below along with their location, exemplary examples and preferred API.

### Command Handlers (aka service objects)

- location: `(app/models)`
- example: [`Feed::MessageProcessor`](https://github.com/airslie/renalwarev2/blob/master/app/models/renalware/feeds/message_processor.rb)

We use command handlers when:

* two modules need to communicate with each other without being tightly coupled via a Pub-Sub mechanism (Wisper).
* a command (request) involves multiple model instances to be manipulated

API:
- Follows the naming convention "{verb}{model}" e.g. `RegisterPatient`
- All dependencies are injected via the constructor
- A `#call` method which accepts the params

### Query Objects

- location: `(app/models)`
- example: [`PrescriptionsQuery`](https://github.com/airslie/renalwarev2/blob/master/app/models/renalware/medications/prescriptions_query.rb)

Query objects encapsulate a specific query against the database. We use them for complex queries that exceed our threshold for using AR scopes.

API:
- follows the naming convention "{model}Query" e.g. `PrescriptionsQuery`
- all dependencies are injected via the constructor
- a `#call` method to invoke the query returning a AR relation
- a `#search` method if required to support Ransack in the UI
- does not include pagination, this is added in the controller

### Presenters

- location: `(app/presenters)`
- "traditional" presenter example: [`HD::ProfilePresenter`](https://github.com/airslie/renalwarev2/blob/master/app/presenters/renalware/hd/profile_presenter.rb)
- "Clean Architecture" presenter example: [`Pathology::CurrentObservationResults::Presenter`](https://github.com/airslie/renalwarev2/blob/master/app/presenters/renalware/pathology/current_observation_results/presenter.rb)

Presenters come in two styles:

1. a "traditional" presenter decorates ActiveRecord models with presentation logic. This is the "traditional" presenter you would expect in a Rails application. We use this style of presenter to avoid the views getting cluttered with logic or to isolate presentation logic we wish to unit test.
2. the second style receives a collection of models and creates a new structure which is used purely for presentation purposes. This type of presenter is closer to those found in Robert Martin's ["Clean Architecture"](https://8thlight.com/blog/uncle-bob/2012/08/13/the-clean-architecture.html). We use this style of presenter for views that aggregate information.

API ("traditional" presenter):
- follows the naming convention "{model}Presenter" e.g. `ProfilePresenter`
- a constructor that receives the model it decorates
- contains accessor methods that decorate existing methods or adds new convenience methods

API ("Clean Architecture" presenter):
- follows the naming convention "{collection}::Presenter" e.g. `CurrentObservationResults::Presenter`
- a `#present` method receives an AR relation and returns an array
- used in conjunction with a ViewObject
- from the example above, see [`Pathology::CurrentObservationResultsController`](renalwarev2/app/controllers/renalware/pathology/current_observation_results_controller.rb) to see how they interact

### Value Objects

- location: `(app/values)`
- example: [`Duration`](https://github.com/airslie/renalwarev2/blob/master/app/values/renalware/duration.rb)

[Value objects](http://martinfowler.com/bliki/ValueObject.html) represent concepts whose equality is based on their value in contrast to entities whose equality is based on their identity. Values objects are either persisted inline as attributes with a model (e.g. `Gender`) or as a separate table (e.g. `Address`). We often extract values when we identify behavior related to that value type represented as an attribute on an ActiveRecord model.

### Documents

- location: `(app/documents)`
- example: [Transplant::DonorOperationDocument](https://github.com/airslie/renalwarev2/blob/master/app/documents/renalware/transplants/donor_operation_document.rb)

Documents are used to embed complex "forms" in a model and are persisted as JSONB.

### Factories

- location: `(app/models)`
- example: [Accesses::AssessmentFactory](https://github.com/airslie/renalwarev2/blob/master/app/models/renalware/accesses/assessment_factory.rb)

Factories create instantiate other objects and deal with the logic related to that.

API:
- follows the naming convention "{model}Factory" e.g. `AssessmentFactory`
- all dependencies are injected via the constructor
- a `#build` method to instantiate the model

### Other Archetypes

We don't limit ourselves to just these archetypes. We extract classes as need to encapsulate behavior or variation in the application as needed (e.g. strategies). Overall, we favor small objects that are composable.

# Testing

We select the most appropriate test strategy depending on what type of feature we are developing. Our selection balances cost (i.e the time to run and code to maintain), risk and the type of feedback we wish to receive (stakeholder communication, regression testing or software design). Tests are designed to be as robust as possible. When testing the UI, we avoid being overly specific (e.g. specifying deeply nested DOM elements) to avoid brittleness and encourage refactoring.

## Acceptance Tests

- location: `(features/)`
- example: [Changing the Waitlist Status](https://github.com/airslie/renalwarev2/blob/master/features/renalware/transplants/changing_the_wait_list_status.feature)

A business-oriented approach known as "Specification by Example" drives the development of features to ensure we are "building the right thing". These executable specifications create our acceptance test suite which is implemented with Cucumber. Acceptance tests:

- document business requirements in a declarative manner, independent of implementation
- explore the requirements at the domain model layer first
- include tests for the UI if required by switching out the domain API for the web API
- only test one happy and error path through the UI

Here are some guidelines for writing acceptance tests:

- features start with a gerund. i.e. Determining, Creating.
- scenario titles are based on the phrase "That time when...". e.g. Scenario: A clinician updated a patient's registration
- the `Web` World is only used by the `When` statements. `Given` statements prepares the scenario using direct-model access, not the UI. `Then` statements verifies the scenario using direct-model access, not through the UI.
- for auxiliary data required in the test database (i.e. having a populated drugs table), try to use the existing fixtures as much as possible or create your own (located in features/support/fixtures)

## Unit Tests

- locations: `spec/models, spec/presenters, spec/mailers...`
- examples: [`HD:Session`](https://github.com/airslie/renalwarev2/blob/master/spec/models/renalware/hd/session_spec.rb), [`Letters::Letter::Typed`](https://github.com/airslie/renalwarev2/blob/master/spec/models/renalware/letters/letter/typed_spec.rb)

Unit tests are used for testing responsibilities of objects in relative isolation. They help us "build the thing right" and give us design feedback. Not all unit tests are  completely isolated in the classic sense as specific types such as ActiveRecord models and Query objects will require access to the DB.

## Integration Tests

- location: `(spec/integration)`
- direct request example: [`Configuring event types`](https://github.com/airslie/renalwarev2/blob/master/spec/integration/renalware/events/event_types_spec.rb)
- integration test example: [`Searching drugs`](https://github.com/airslie/renalwarev2/blob/master/spec/integration/drugs/search_drugs_spec.rb)

Integration tests give coverage and confidence that is not provided by our Acceptance or Unit Tests. These tests produce a HTTP request directly (i.e. tagged with `type: :request`) or by a browser driven by Capybara (i.e. tagged with `type: :feature`) giving us two styles:

_Direct request_ specs assert on request headers, status codes and direct model access to verify state.
GET requests simply assert a success status is received. We don't make any assertions on the HTML. We use specs for GET requests simply to ensure things are integrated correctly, i.e. that we treat them as "smoke" tests. We use this style of integration testing for *low risk* system components such as managing lookup tables and do not interact with complex domain behavior.

_Browser driven_ specs assert on the page body returned. We use this style of integration testing for testing complex javascript interaction or where the strategy outlined above in Direct Request testing does not provide enough confidence. Note we use RSpec's standard DSL, i.e. we do not use Capybara's "feature" DSL.

## What we don't do

- controller specs
- route specs
- helper spec (if the logic is complex enough to be tested then they should be extracted into a class and the class should be unit tested)
- test associations in AR models

## Legacy Tests

Tests that do not follow these conventions have `legacy` attached to there filename or directory. Ideally, these will be migrated in the future.
