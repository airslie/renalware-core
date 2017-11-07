# Change Log

All notable changes to this project will be documented in
this [changelog](http://keepachangelog.com/en/0.3.0/).
This project adheres to Semantic Versioning.

## Unreleased
### Added
### Changed
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
