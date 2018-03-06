# Change Log

All notable changes to this project will be documented in
this [changelog](http://keepachangelog.com/en/0.3.0/).
This project adheres to Semantic Versioning.

## Unreleased
### Added
### Changed
### Fixed

## 2.0.0.pre.rc12
06-03-2017

### Added
- Use a modal to ask if letter should be marked as printed (ie completed) after printing

### Changed
- Capture the who and when of letter state changes
- Use new database columns to restrict and order the pathology observations to display
- Introduce frozen_string_literal comment in presenters, spec and cucumber features.
  Roll out across the rest of the app later.
- Add Prescriptions to the API

### Fixed
- Removed roguw column in aki_alerts
- FireFox layout fix - we now use flexbox CSS on patient pages
- Remove Print All button on Renal -> Letters. It didn't do anything.
- Use a transaction around HL7 processing to prevent orphaned observations and
  observation_requests if once of the OBXs fails (causing a delayed_job retry).

## 2.0.0.pre.rc12
27-02-2017

### Added
- UKRDC export rake task

### Changed
- Default sort order to HGB desc on all MDMs
- Sort Clinical Studies list
- Add address fields to API
- Limit delayed_job retries to 10 and do not remove from queue once exceeded
- Ensure OBR placer ids are unique in UKRDC XML
- Cache rendered PDFs using Cache::FileStore not the the default Rails.cache

### Fixed

- #1948 Fix patient side menu when patients have markup in event notes

## 2.0.0.pre.rc11
21-02-2017

### Added
- Enable clearing the cache form the app when a super admin
- Add fragment caching in key places
- Add link to approve users at bottom of admin dashboard
- Add postgres dump rake task and configure in schedule.rb (for whenever)
- Add simple API for accessing patient demographics

### Changed
- Improve display of admin users table
- Set default order to HGB date on PD and HD MDMs
- Remove access to some audits for now as performance needs optimising
- Add missing fields to AKI Alerts
- Add unique display_order columns to observation_descriptions to support future ordering

### Fixed
- Changed events order to datetime desc
- Fix display of Test Cancelled in pathology results

## 2.0.0.pre.rc10
13-02-2017

### Added
- Handle display of cancelled OBX tests
- Add psychosocial fields to Demographics

### Changed
- Only list last 10 dates of pathology in MDM. Includes refactor of the Historical Pathology view
to avoid excessive memory usage
- Reduce space taken up in clinical grey bar
- Refactor Clinical Summary view so make it easier to extend in host app
- Update units of measurement and seeds #1924
- Update CAPD bag volumes
- Expand PD Fluid Types list
- Pin gem versions ready for 2.0 release

### Fixed
- Bug when querying for path by OBX codes and codes is null #1936
- Bug where its possible to Back in the browser once logged out #1934
- Bug where no missing obs date in HL7 - now ignores OBX and logs a warning #1926
- Bug where NHS No repeated in MDM table columns

## 2.0.0.pre.rc9
07-02-2017 - Created to debug gem resolution issue.

## 2.0.0.pre.rc8
06-02-2017

### Added
- Clinical grey bar on patient screens, displaying latest key results

### Changed
- Display only 10 path results on MDMs
- Only output OBX results having a loinc_code in UKRDC XML
- Other UKRDC XML changes
- Table column width tweaks

### Fixed
- Add missing deleted_at indexes

## 2.0.0.pre.rc7
29-01-2017

### Added
### Changed
- Email handling when letter approved

### Fixed

## 2.0.0.pre.rc7
29-01-2017

### Added
- Patient Investigations

### Changed
- UKRDC XML changes
- don't display path results on letter if letterhead forbids it

### Fixed
- support HL7 messages with > 1 OBR segment
- set updated_at on pathology_current_observation_sets when jsonb is updated with a new result

## 2.0.0.pre.rc6
16-01-2017

### Added
- EPR support for saving PDF to filesystem
- New drug types
- Support for adding custom links in patient nav

### Changed
- UKRDC XML changes
- Hide un-measured clinical measurements in letters

### Fixed
- HL7 Caret fix

## 2.0.0.pre.rc4
16-01-2017

### Added
- GP and Practice import via file

### Changed

### Fixed
- Minor bug fixes

## 2.0.0.pre.rc4
16-01-2017

### Added
- Support for emailing letter to GP once approved
- Support for emailing letter to an EPR endpoint once approved
- Migrate to Ruby 2.5
- Add Low Clearance Profile and Low Clearance section in Patient Nav

### Changed
- Prefix Alerts with `Alert:` and change styling
- Expire users after 90 days of inactivity
- RSpec housekeeping
- Patient LH Menu made more compact
- Reinstate and improve formatting of NHS logo in letters
- Ensure there is a link to the MDM from each patient

### Fixed
- Mailer previews not displaying
- New clinical letter for patient without recent pathology
- Double render in Tx donor workup #show
- Order of recent investigations (recent pathology) in Letters

## 2.0.0.pre.rc3
18-12-2017

### Added
- Consults

### Changed
- Letter pathology layout

### Fixed

## 2.0.0.pre.rc2
17-12-2017

### Added
- Ability to search for and filter users in Admin -> Users
- Cache latest pathology observations in a new table to speed up displaying current pathology

### Changed
- Change dashboard to display user fullname not username
- Update gems

### Fixed

## 2.0.0.pre.rc1
10-12-2017

### Added
- Beta banner with option to report bug or give feeback

### Changed
- New column on observation_descriptions to capture LOINC code
- Show only 10 letters and events in Clinical Summary with View All option to see the remainder

### Fixed
- Low Clearance MDM now uses `Low Clearance` not 'LCC' modality

## 2.0.0.pre.beta13
01-12-2017

### Added
- Freeze Pathology in Letter
- Low Clearance MDM
- Add Tags to Bookmarks

### Changed
- Housekeeping - new indexes, remove unused code
- Migrate to Cucumber 3

### Fixed

## 2.0.0.pre.beta12
21-11-2017

### Added
- Support running delayed_job as a daemon
- Added `tags` field to Bookmarks

### Changed
- Moved renalware core database objects into the `renalware` postgres schema
- Use lograge for single line logging in production
- Support Postgres 10 on CI and Heroku review apps
- Use a separate log for delayed_job
- Mirth feed processing no longer creates new patients
- Reduce the ajax session expiry polling frequency and don't log those requests

### Fixed
- UKRDC XML changes

## 2.0.0.pre.beta11

### Added

### Changed
- Remove unique index on patient locals_ids to aid data migration
- Moved default drugs seeds to the demo seeds as these are site-specific

### Fixed

## 2.0.0.pre.beta10
07-11-2017

### Added
- Admission Consults
- PD Audit
- Renal Reg return checks
- Clinical Studes
- Anaemia Audit

### Changed

- UKRDC XML improvements

### Fixed

- ESRF address not sticking #1708
- Search by hospital number now case-insensitive
- Pagination admin/users

## 2.0.0.pre.beta9
11-10-2017

### Added

- HD Sesssions in UKRDC XML
- AKI Alert UI
- Add legacy_patient_id to patients table
- Bone audit
- Some seed rationalisation
- Temporary link on patient screen view UKRDC xml
- HD Diary

### Changed

### Fixed

## 2.0.0.pre.beta8
25-09-2017

### Added
- Electronic CCs
- Admission Requests (To Come In list)
- HD Diurnal Periods
- HD Unit Stations
- Forgotten password feature
- Add Pathology to UKRDC XML

### Changed
- Updated to Ruby 2.4.2
- Updated gem dependencies in Nokogiri to fix security warning
- Add dialysis shortfall > 5% to HD Audit
- Update Rails to 5.1.4
- Housekeeping to speed up tests on CI

### Fixed
- Auto session timeout check redirects to / when you are are password reset or signup pages


## 2.0.0.pre.beta7
10-09-2017

### Added
### Changed
### Fixed
- Added the vendor/assets path to the gemspec to fix missing assets when consuming the gem
- Added the spec/support and spec/factories paths to the gemspec to make testing easier in the host

## 2.0.0.pre.beta5

09-09-2017

### Added

Significant additions:
- Patient Alerts
- Private Messaging
- Terminate a patients medications on death
- Automatic logout on session timeout
- Combine Draft and Pending Review letters in the user dashboard
- Event filtering
- Add EPO drugs to HD MDM
- UKRDC XML additions
- Audits
- Patient ESI print-out
- Patient Peritonitis print-out
- PD Line Change events
- Display PD Line changes on the PD Dashboard
- PD Training Sessions
- Add Standing BP to clinic visit
- List HD preference mismatches

### Changed

- Remove Site from Access Profile and Plan
- Styling improvements

### Fixed

- Various bugfixes

## 2.0.0.pre.beta2

### Added

- Add Access Catheter Insertion Techniques to Access Procedure
- Add allergies to clinical letters
- When Clinic visit is printed it hides filters a adds space under each row for notes
- Allow patient search with a comma and no spaces e.g. `Rabb,Rog`
- Events notes field supports bold, italic etc
- Plasma Exchange event type added

### Changed

### Fixed

- Snippets not inserting into event notes field.

## 2.0.0.pre.beta.1

- With this and previous releases, see commits for changes.
