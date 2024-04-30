# Change Log

All notable changes to this project will be documented in
this [changelog](http://keepachangelog.com/en/0.3.0/).
This project adheres to Semantic Versioning.

## Unreleased
### Added
### Changed
### Fixed

## 2.4.2
### Added
- Add Medically fit for discharge checkbox on HD slot requests #4670
- Allow a admin to soft-delete an HD prescription administration #4668, #4738
- Capture when a patients requests their UKRDC data be anonymised #4662
- Alternative experimental chart support for reports using the chart_raw column on view_metadata #4618
- Add a demo scheduled function to illustrate updating patient.send_to_renal_reg #4705
- Display patient group directions on read-only HD Session view #4742
- Add Tx 'Kidney and other' option to recipient operation and wait list registration #4739
- Replay historical pathology messages when new patient added #4411
### Changed
- Add titles eg '2. Well' to Clinical Frailty Scores events #4697
- Display runtime errors to superadmins #4687
- Display L or D against prescription dates in HD protocol #4676
- Load report data asynchronously after the page has loaded #4671
- Ensure modality history is editable by Admins and Superadmins #4635
- Update Rails to 7.1 #4695
- Upgrade to Ruby 3.3.0 #4708
- Icon housekeeping #4709
- Use OBR.7, falling back to OBR.6 if missing, instead of OBX.14 when storing pathology_observation.obseved_at #4752
- Performance and usability improvements to the Renal->Events and Patient->Events pages #4758
- Switch from kaminari to pagy pagination library (already used in many places) in the following locations
  - admin/users
  - clinical/dry_weights
  - admin/drugs
  - hd/unmet preferences
  - Patient -> letters
  - admin/drug_types
  - Patients -> Patients list
  - Renal -> RR Preflight checks
- Reporting module refactor - please test
### Fixed
- Allow sign in page to scroll correctly #4698
- Fix bug displaying unnecessary Overlapping Modality message #4704
- Prevent bots crawling documentation #4710
- Fix bug loading reports 'Configure columns' modal on MDMs/reports #4716

## 2.4.1

### Added
- Add Patient Group Direction options to HD Session, with admin UI to configure #4478
- Add a new 'HD Prescriber' role and stat prescriptions #4464
- Allow customising the landing page for patient links in reports #4453
- Allow editing and deleting modalities #4436
- Set a future termination for HD prescriptions #4559: When creating a prescription where administer_on_hd=true then assign a prescription_termination with a date 6.months in the future. This value is configurable via Renalware.config.auto_terminate_hd_prescriptions_after_period and to disable the new behaviour set this to nil. When creating a prescription where administer_on_hd=true and stat=true then set a future termination date of 14 days
- Add DSA 'Donor-specific antibody' to Tx Investigation dropdown #4566
- Add a report to identify patients sharing the same NHS number #4579
- Support simple line graphs in reports #4605

### Changed
- Don't allow administration of future HD prescriptions #4562
- Include unit_dose_form_size_uom_code dm+d UOM #4556
- Only search the last 1m rows when calculating urrs #4527 to speed the query up.
- Store and display how many times a report is viewed #4499
- Identify dmd drugs in prescriptions view #4476 using a key
- ESI/PE prescription display changes #4472 - Now that only there is only one list of meds on this page (combining current and historical), change the title 'Current' to 'Antibiotics/Routes'
- Break out HD and Tx opt-level menus #4483
- Mark a message as read after replying #4467
- Changes to the way modalities are added #4438 - Stop capturing modality change reasons, enforce change type, capture source and dest hospitals if change type require them
- Disable inactivation of non-dmd drugs during nightly dm+d syncing #4501
- Include the current access profile/plan as first row in respective history tables #4541
- Add unique index to drug frequencies #4548
- Allow Access Plan type dropdown to be searchable #4552
- Display future HD prescriptions up to 10 days ahead on HD protocol #4567
- Don't validate needle_size when signing off HD Session #4577
- Omit null vales when charting pathology #4588
- Soft delete patient worries #4594
- Support per-message type (ADT, ORU etc) patient location strategies #4612
- Add 'dynamic' patient locator strategy for MSE ADT HL7 messages #4614
- Terminate given HD stat prescriptions immediately if they have a future termination date #4631

### Fixed
- Use prescription.drug_name when displaying #4539 to ensure trade family name is included
- Fix PKB typo #4498
- Omit inactive drugs from admin drugs page #4491
- Fix error adding PD bag type if glucose-strength omitted #4432
- Fix occasional race condition creating patient from eg AKI HL7 msg #4502
- Reinstate drug colour-code key on prescriptions page #4558
- Remove blank NHS numbers from duplicate_nhs_numbers view #4580
- Fix 'undefined local variable or method operation' in RecipientOperationsController#show #4582
- Fix display of PD regime delivery frequency #4585
- Fix problem sorting (was sorting by problem notes date not problem date) #4589
- Fix prescription colour highlighting on clinical summary #4590
- Prevent QR code table rows from spanning page breaks #4591
- Allow prescriptions with future termination dates to be 'terminated' #4592
- HD Slot request fixes - validate present of notes - any user can see the historical tab - use a modal for the edit form - remove references to specific_requirements column  #4598
- Use correct (dm+d) dose unit on homecare delivery forms #4609
- Fix problem/prescriptions overlay on clinic visits form, preventing clicking 'Create' when patient has a long list of problems #4613

## 2.4.0

### Added
- Highlight non-contiguous entries in the modality listing #4437
- Add 'hospital ward' option to hospital unit types #4452
- Log near-match occurrences in HL7 ingestion #4413 Where we match on number but not DOB, log to a table and include the patient id and feed message id. Display these log entries in the backend so an admin can view and resolve manually if necessary.
- Identify home HD Sessions in HD Sessions table with a home icon #4423
- Extract ORC filler_order_number from HL7 when persisting to feed_messages (ready for historical pathology replay) #4427
- Extract ORC order status from HL7 when persisting to feed_messages (ready for historical pathology replay) #4425
- Highlight non-contiguous entries in the modality listing #4437
- Add drop-down urine glucose to clinic visits and then include in the letters #4386
- Add clinic visit location in order to support virtual clinics #4391
- Add drug type and dm+d filters to drugs list #4409
- Add home_machine_identifier to HD Profile for Baxter HDCloud support #4405
- Add 'Relaxation of restrictions' option to dietetic CV interventions #4382
- Add hospital centre filter to the live donor list #4342
- Support html and text mail in MS Graph API #4383
- Support sending email via MS Graph API from NHSMail mailbox #4353
- Schedule materialised view refreshing #4349
- Add support for using good_job HL7 processing via a feed_raw_hl7_messages queue table #4267
- Allow choosing a code group when viewing historical pathology #4336
- IgAN prediction tool #4335
- Add regex columns to RaDaR diagnoses table #4341
- Store RaDaR cohorts and diagnoses #4338
- Add QR code links to online articles to letters #4103
- Add VND Risk Assessments #4272
- Add notes and admin notes to toggled dietetic row #4293
- Create a Transplant Review event similar to Medication Review. Will be invokeable from a new Tx Dashboard screen #4300
- Add an 'API log' page in the admin section to make it easier to debug issues #4324
- Add a job type that can execute a SQL function, eg via cron #4328
- Add 'View All' button to API logs component on superadmin dashboard #4327
- Switch to using dm+d drugs in prescriptions. The drug list is updated automatically #4247
- Introduce a Hospitals::Department model to capture the telephone/address of an administrative department #4250
- Add RR19 malignancy sites to database #4219
- Add Visit Type filters at the top of Dietetic MDM list #4210
- Add RR outcome code to Death::Location in preperation for RR5 dataset #4203
### Changed
- Make Dietetic MDM Patients a materialised view #4369
- Persist HL7 msg patient identification to feed_messages.local_patient_id* #4357
- Save id of source feed_message on pathology_observation_request #4365
- Add N/A to the drop down list for sga_assessment in dietetic clinic #4343
- Display spinner when Ajax-loading report table #4374
- Ensure all emails are sent using ActiveJob #4347
- Restrict HD Session access type choice by hd_vascular=true #4340
- Prescriptions column heading changes - add a new column 'Stop on' after 'Prescribed on' - rename 'Terminated on' to 'Stopped on' #4260
- Add missing dietetic CV data items to the toggled table cell #4258
- Add rounded borders and add more spacing to form inputs #4273
- Add new columns to drug_frequencies to allow dose calculation #4259
- Trim leading/trailing space around items in HL7 PID segment #4296
- Add sortable columns to reports page #4269
- New patient locator strategy using NHS or any hosp number and ignoring DOB #4288
- Ensure soft-deleted event types remain visible where previously used #4311
- Rename Mean URR to to URR in HD letter template and add URR date #4312
- Add new columns to feed_messages (local_patient_id etc) to support (later) migration of patient_identifiers to local_patient_id* columns #4310
- Sort Dietetic MDMs by clinic visit date descending #4315
- Move to Rails 7 and Ruby 3.2
- Convert UpdateRollingPatientStatisticsJob to an Active Job #4256
- Date picker and time picker enhancements #4254
- Move drug frequencies into a database table #4246
- Login page styling improvements
- Change references to RPV to PKB in UI #4237
- Migrate Audits to Reports #4188
- Move mini clinical profile above alerts on patient layout #4165
- HD Session form PDF changes - Add Solution flow from HD profile next to Blood Flow and indicate if Worry #4164
- Refresh browser page automatically in development #4243
### Fixed
- Fix missing QR codes in PDF letter #4381
- Fix dm+d millilitre mapping (ml/l is now ml) #4422
- Fix column highlighting in pathology tables #4428 A bug had emerged where, if the 'view' onto the pathology changed, eg from 'default' to 'HD', the column would not highlight when hovered-over (a feature to help the user identify the relevant column header in the table). Also fix missing popup on blue triangle comments in the recent pathology view.
- Fix error adding PD bag type if glucose-strength omitted #4432
- Correct the default date in the filter in Appointments list #4390
- Address dm+d mapping issues #4408
- Fix default_patient_link usage in dynamic reports #4350
- Ensure termination date is editable when editing a prescription #4276
- Fixed bug creating an event when changing dropdown from eg Clinical Frailty Score to Medication Review (missing partial) #4303
- Fixed error creating letter from dietetic visit #4292
- Use the ClinicVisitPolicy for Dietetic clinic visits so they are no longer editbale after 7 days #4261
- Include a name when JIT-creating Kt/V observation description #4220
- Reply to a message should reply to all recipients in original message #4208
- Fix error viewing own letters #4193
- Trim whitespace from local_patient numbers when saving new patient #4169
- Error when deleting a clinic visit created from an appointment #4162
- Fix patient_scope syntax to correct Worryboard#show error #4160
- Reinstate pathology table top scroll bar #4183

## 2.3.2

### Added
- Add Nursing Experience Level to Admin => Users page #3951
- Create a job to SFTP waiting files to UKRDC from Azure #4134
- Add a turbo-frame spinner component #4140
### Changed
- Generate simple Kt/V along with URR #4151
- Capture where patient would like to die and where they actually died #3918
- Default Site dropdown to current_user.hospital_centre_id on AKI Alerts page #4148
- Letter sections: Use DL/DT/DD #4146
### Fixed
- AKI Alerts filters not persisted if you cancel from the edit screen #4147

## 2.3.1

### Added

- Create Dietetic Assessment #2617
- Create Dietetic Clinic Visit #4078
- Introduce Topic dependent dynamic letter sections #4030
- Use a toast for flash notices #3980
- Support event versioning and soft-delete #3994
- Support per-MDM pathology code groups #4006
- Add warning to prescription administration & new HD session screens #4002
- Add access plan and plan date to AKCC MDM #4036
- Display other recipients in messages tables #3996
- Add `bin/setup` script #4084
- MDM: Add optional optional inclusion of \_bottom partial #4028
- Display clinic name and code on clinic visit letters #4038
- Add Station column to HD Sessions table #4082
- Add basic version of Dietetic MDM list and page #4035
- Add HD housekeeping task to remove stale batch files #4117
- Add Letters housekeeping task to remove stale batch files #4115
- Display count of unread messages next to username in top menu #3984

### Changed

- Allow optional min and max range to dry weights #3952
- Rename `Letters::Description` to `Letters::Topic` #4007
- Integrate BLT research study changes for Heroic #3981
- Activejob agnosticism - Part 1 #3970
- Show links to previous 2 weeks of sessions - #3997
- Update pathology_observations_grouped_by_date SQL view to group by date not datetime #4009
- Switch autoloader to Zeitwerk #4018
- Allow for a pre-existing event_versions table #4025
- Move from content_areas to slots in ArticleComponent #4021
- Skip address validation when syncing ODS data #4052
- Allow clinicians to Edit Adequacy and Pet results #4105
- Include rack-host-redirect and wkhtmltopdf-heroku gems in Heroku demo app #4095
- ❇️ Improve Letter topics dropdown #4093
- 🐛 Fix multiple loading of rake tasks in InvokeRakeTaskJob #4090
- Refactor FlatpickrController to allow for time input #4087
- Limit Pathology Observations to 8 instead of 25 #4088
- Convert Whenever schedule to GoodJob-style background jobs #4061
- Create a UKRDC Treatment entry for every regime change #4081
- I18n improvements #4075
- Add Hospital Centre dropdown when creating a new Patient #4071
- Allow for time zone when deriving HD Session start and stop times #4060
- Correct the logic around patient visibility #4058
- Add Letters housekeeping task to remove stale batch files #4115
- Add HD housekeeping task to remove stale batch files #4117

### Fixed

- Fix seed issue with Super User missing a role #4023
- Fix incorrect beta MDM paths #4034
- Replace deprecated rendered_component usage #4040
- Fix invalid authenticity token errors #4083
- Fix missing table column heading in global events table #4051
- Fix i18n-tasks issue with space after empty keys #4085

## 2.3.0

### Added

- Nascent support (disabled by default) for restricting access to patients by hospital, so that, if
  enabled, a user at hospital X can only see patients at hospital X and not patients at hospital Y.
  Used at BLT.

### Changed

- Introduced clinical study 'investigators' who are users involved in the running of a study.
  This to support the Heroic study at BLT where investigator users can see patients in their study
  even if the patient is at a different hospital to the user.

### Fixed

- Fix badly formatted 'Reactivate account' checkbox in admin/users form #3988

## 2.2.13

### Added

### Changed

- Renamed the internal 'staging' environment to 'uat' (no client testing required) #3976
- Add filtering by subcategory to reports page and improve UI #3975

### Fixed

## 2.2.12

### Added

- Return a 404 on eg /robots123.txt requests to prevent logging an error on Azure healthchecks #3966
- Add reports menu (superadmin only currently) and a sample report HD patients/unit/time #3359

### Changed

### Fixed

- PD PET Adequacy: Add missing column for T4 sample #3948

## 2.2.11

### Added

- Add user group model and support for editing by a superadmin #3835

### Changed

### Fixed

- Keep uploaded files on disk when 'patient attachments' or 'downloads' are soft-deleted #3934

## 2.2.10

### Added

- Allow adding an 'Ease of Assessment (MAGIC)' needling assessments (green, amber, yellow) from
  Access Summary, and display the last 5 on the HD Summary and the latest on the HD Session printout #3914
- Add range validation to height and weight in PD Adequacy #3919

### Changed

- Allow PDFs generated from letters to be cached temporarily in the database rather than in a
  folder, to improve scalability #3925
- Prevent non alphnumeric characters from being entered into patient Postcode fields #392
- Change layout of Transplant MDM - move special pathology above standard pathology #3912

### Fixed

## 2.2.9

### Added

### Changed

- Allow setting OBX RR coding standard in admin UI #3910
- Use PV GPG key for UKRDC encryption and create the GPG keyring just-in-time
- Appointment filtering changes #3840
  - by default use today's date in the date filter. Will show appointments from today onwards onto into the future
  - add a checkbox to allow showing just results for the specified day

### Fixed

- Make pathology columns sort correctly in beta MDMs #3909
- Fix rounding error in KFRE calculations #3902

## 2.2.8

### Added

- 5 and 2 year KFRE calculations #3866
- Display outgoing document stats on superadmin dashboard #3896
- Allow an admin to change the hospital site a user works at #3884
- Map HL7 sex INDETERMINATE to Not Known #3882
- Add superadmin page to allow submission of test/adhoc HL7 messages #3881
- Add a superadmin screen for viewing config settings #3869
- Display in demographics the last time the patient was sent to the ukrdc #3862
- Add low_clearance dialysis_plans table (part 1) for migration away from hard-coded values #3865

### Changed

- Add as-you-type filtering to the admin drugs list #3897
- Bump Ruby version to 3.0.4 #3880

### Fixed

- Hd sessions table columns out of order #3874
- Correct HD Session start/stop time timezones #3875
- Update UKRDC gpg keyring #3867

## 2.2.7

### Added

- Add a date range to AKI Alerts which defaults to 'last 24 hours up to 0945' #3841

### Changed

- Use created_at rather than test timestamp when exporting UKRDC LabOrders #3851

### Fixed

## 2.2.6

### Added

### Changed

- Correct mean weight loss calculation (was not excluding missing values) #3831
- Add HD and PD to AKCC plan #3834
- Allow editing OBX loinc_code in superadmin UI #3843
- Allow printing HD-only drugs from a patient's prescriptions page #3806
- AKI logic changes #3846
  - skip AKI alerts if patient's curr modality is marked as #ignore_for_aki (can change in admin UI)
  - skip if age < 17
  - skip if curr modality is in hd, pd, death
  - when score is 1
    - alert unless no alert within 14 days with any score (1,2,3)
  - when score is 2 or 3
    - alert if no alert in past 14 days
    - alert if only score in previous 14 days was for a score of 1
    - do not alert if alert in past 14 days was for a score of either 2 or 3

### Fixed

- Fix truncation of column values on patient MDM list #3849

## 2.2.5

### Changed

- Add author's GMC code as a TXA.5 subfield in MDM^T02 HL7 messages #3820
- Exclude death but not low_clearance modalities from AKI alerts #3823
- Do not create AKI alerts for patients < 17 years old #3816
- Add a trigger to maintain the legacy performed_on date #3829
- Add a msg on the new event form to indicate that the event will generate a PDF #3794

### Fixed

- Disable datepicker autocomplete in filters on clinic visits page #3818
- Fixed bug where station not saving in HD session form #3830

## 2.2.4

### Added

### Changed

- Conditionally enable rolling comorbidities
- Toggle worryboard notes #3805
- Don't allow a patient DOB < 01-01-1880 #3810
- Add option for a hosp to derive and store missing URR pathology #3809
- Allow clearing named_nurse and named_consultant in clinical profile #3802

### Fixed

- Error in HD Session show page caused by duplicate comma
- Kwarg error invoking SavePdfLetterToFileJob

## 2.2.3

### Added

- Decease patients when HL7 death date arrives #3675
- Add ability to have an overnight HD session #2267
- Use EventTypes table to drive Event edit/delete policies #3787
- Allow admin to configure which event types are sent to EPR #3793

### Changed

- Disable events and letters caching on clinical summary #3790
- Add CR at end of MDM^T02 doc out msg #3789

### Fixed

## 2.2.2

### Added

- Add a UKRDC activity component to the superadmin dashboard #3783
- Allow a user to be 'banned' #3781
- Add category to worryboard #3763
- Add GMC code to users table #3771
- Search SNOMED procedures (in addition to clinical findings) when looking up problems #3756

### Changed

- Changes to outgoing MDM T02 HL7 document messages #3779, #3778
- Allow adding a date to a problem #3774
- Omit sex from PID when outputting MDM^T02 docs #3770
- Include a PV1 segment in Outgoing document HL7 MDM^T02 message #3769
- Increase PD dwell time to 240 minutes #3762
- Wrap UKRDC DialysisSession elements inside DialysisSessions (UKRDC export XML) #3759

### Fixed

- Fix issues with UKRDC export
- Use \r not \n in base64 encoded PDFs in MDM^T02 messages #3764
- Error soft-deleting a clinic in use #3750
- Fix pathology code group sorting on HD MDM page #3749

## 2.2.1

### Added

- Add hospital centre to patient
- Add 'host_site' option to hospital_centres
- Add AKI Alert level filter to AKI Alerts page #3701

### Changed

- Changes to reduce impact of NHS Terminology Server being unavailable #3712
- Avoid caching 'problems' #3710
- Make hosp number presence validation optional #3703
- Add legacy_comment to pathology_observations #3698
- Do not save an OBR when all its OBXs are empty #3697

### Fixed

- Fix error raising ArgumentError #3704

## 2.2.0

### Added

- Allow mapping OBX codes based on HL7 sending facility/application #3661
- Create AKI Alerts #3678
- Allow a superadmin to view a paged list of outgoing documents #3673
- Support sending an approved letter as an HL7 message to Mirth #3659
- Allow hiding modality descriptions in the superadmin UI #3668
- Capture OBR filler_order_number #3667
- Display a deprecation message to IE users #3619
- Allow administration of letter descriptions by a super admin #3606
- Allow administration of letter descriptions by a super admin #3606
- Add support for a superadmin to add/edit/(soft) delete clinics #3650
- User list - add username to display #3625
- Persist HL7 PID patient ethnicity #3626
- Implement choosing problems from snomed list #3531
- Display SNOMED ID in problems list #3602
- Add missing devise views and customise them #3587
- Display password policy description #3586
- Add rolling comorbidities #3457
- Map hospital numbers in HL7 PID segment to correct local patient id using assigning authority #3546
- Display Nags on patient screens #3460
- Add HD DNA Nag #3542
- Add position and signature fields to sign up form #3549
- Bone/Anemia graphs #3456

### Changed

- Toggle open notes in prescriptions table #3685
- Use OBR observation date/time if OBX one is missing #3680
- Add HL7 visit_number to appointments table #3670
- Add smomed ID after description in search list #3655
- Assign a clinic default modality description to new patients when importing appointments #3660
- Allow read-only admin access to letter descriptions #3658
- Handle ADT Clinic messages #3632
- Move Consultant model from Renal to Clinics module #3657
- Enforce unique local_patient_id[2,3,4,5] #3578
- Add support for a superadmin to add/edit/(soft) delete clinics #3650
- Set a maximum batch print size for letters #3608
- Add new dose units millimole:mmol tablespoon:tbsp teaspoon:tsp #3564
- Handle max failed login attempts for users #3551

### Fixed

- Fix broken styling on password reset form #3682
- Fix ODS sync ruby keywords error #3669
- Prevent empty string being saved to local_patient_id\* columns #3653
- Do not retry letter batch printing jobs #3600
- Fix day calculation in patient_nag_clinical_frailty_score fn #3589

### Added

## 2.1.2

### Added

- Add named nurse and named consultant to dynamic MDM views #3503
- Add patient attachments (backported from from feature/heroic) #3493
- Add new items (Blown Fistula, Multiple Cannulation Attempts, Prolonged bleeding) to HD session complications list #3488
- Allow a user to create a 'medication review' event #3479
- Add Circuit Loss to HD Session form #3463
- (MSE) Add column to store READ code for drugs #3459
- Record HD Station in HD Session form #3453
- Add HD Session 'washback quality' field #3440
- Add named consultant as filter on HD MDM list #3436
- Add substitution percent to HD profile #3487
- New Research Event Type Category #3352
- Add assistance options to CAPD regime #3508
- Add toggle-able sections for Prescriptions and Problems to the Clinic Visit form #3510
- Ruby 3.0 compatibility #3494
- Add named nurse filter to ongoing hd sessions list #3513

### Changed

- Add shortcuts to create ACP and CFS events on clinical profile page #3499
- Use red to highlight missing ESRF date in patient header #3480
- HD Session: Disallow HD post-weight if >7kg different from pre-weight #3455
- PD MDM change sort order so Nulls appear last #3452
- Track changes to drugs table #3449

### Fixed

- Patient search not working correctly #3501
- UKRDC export - Change UKRR TXT code for live related child #3486
- (PD) Move Dialysate Na field into correct HTML table column #3474

## 2.1.1

### Added

### Changed

### Fixed

- Fixed event category migration error

## 2.1.0

### Added

- Add event categories (already supported at Barts) #3419

### Changed

- Use approved_at date as date displayed on final letter #3313
- Move named nurse into clinical profile #3424
- Exclude already-emailed letter recipients from batch printed letters #3388
- Improve support for other locales including proof-of-concept Portuguese support #3386
- Rename Low Clearance to Advanced Kidney Care #3383
- Use icon to indicate letters notes present, and exclude letters with notes from batch printing #3432

### Fixed

## 2.0.167

### Added

### Changed

- Allow superadmin to edit and delete a vaccine event #3408

### Fixed

- Sort Virology Vaccinations by date_time descending [#3405](https://github.com/airslie/renalwarev2/issues/3405)
- Should not be able to edit Vaccine and Clinical Frailty scores #3351

## 2.0.166

### Added

### Changed

### Fixed

- Vaccination alert not displaying correctly when its vaccination type is soft-deleted #3400

## 2.0.165

### Added

- Add Vaccine Type admin page where a superadmin can add/edit/soft-delete/reorder vaccination types #3399

### Changed

### Fixed

## 2.0.164

### Added

### Changed

### Fixed

- Fix virology dashboard url in vaccination alerts

## 2.0.163

### Added

### Changed

### Fixed

- Fix migration version error

## 2.0.162

### Added

- Display latest COVID vaccination as an alert on patient pages #3395

### Changed

- Expire letters in the PDF cache after 4 weeks #3393

### Fixed

## 2.0.161

### Added

### Changed

- Move vaccination types to a database table #3390

### Fixed

## 2.0.160

### Added

- Support COVID 19 (1 & 2) Vaccinations #3382
- Add Hosp or GP at end of each prescription in clinical letters #3373
- Support HL7 sex 'BOTH' and map to Not Specificed (NS) #3379
- Use CRLF line endings when rendering letter RTFs with Pandoc #3378

### Changed

### Fixed

## 2.0.159

### Added

### Changed

- Add an optional drug when creating a vaccination event #3342
- Javascript enhancements #3355
- Force HTTPS on Heroku #3344

### Fixed

- Removed duplicates in medication_current_prescriptions SQLview #3334
- Active consult alert colour incorrect in dev #3364
- Add latest pd line change event to dynamic pd mdm #3361
- Fix medication_current_prescriptions view #3334
- Remove 'important' tailwind setting #3345

## 2.0.158

### Added

### Changed

### Fixed

- Incorrect messages count on clinical summary #3340

## 2.0.157

### Added

### Changed

### Fixed

- Resolve clinic_visit bmi overflow issues due to invalid height/weight data

## 2.0.156

### Added

### Changed

### Fixed

- Fix migration version error

## 2.0.155

### Added

- Add Bone Meds tab to prescriptions on MDM screens #3314
- Store units of measurement supplied in HL7 feed #1881
- Add new (non-admin) Users page #3317
- Make drug type codes unique in database
- Display last signin datetime on user's dashboard #3311
- Add pilot configurable SQL-view-based alternative MDM screens #3127
- Add 'Give on HD' filter to prescriptions screen #3283
- A superadmin can view/edit a list of observation descriptions #3257
- Add messages about a patient to clinical summary #3282
- Add a numeric nresult to pathology_observations table #3260
- Add Active Consult flag to alerts #3069
- Add BMI to all dynamic MDMs #3315
- Prepare to use pathology code groups on letters #3330
- Document how groups of pathology results are configured for display #3331

### Changed

- PD Adequacy urine changes - add hint to indicate that 0 urine means anuric #3296
- Sort letter descriptions by a new position column, then by name #3309
- Remove 'raise notice' calls from pathology triggers #3281
- Medication list in letters - separate out Give on HD drugs #3284
- Display peritonitis episodes ended_on dates in PD summary #3303
- Display all virology statuses on HD protocol even if Unknown #3289
- Display user name by Allergies in Clinical Profile screen #3278
- Add more blood values to HD protocol #3290
- Add the creating user to the worryboard filter #3273
- Display prescription end date in PD Peritonitis episodes #3310
- UKRDC LabOrder changes in exported XML #3333
- Update tailwindcss & remove foundation-rails gem #3326
- Move Sort AR extension into Sortable concern #3336
- Make drug type codes unique in database #3320

### Fixed

- List bullet points not displaying when editing letter in Trix editor #3304
- Don't track visits to drug lookup json api #3322

## 2.0.154

08-07-2020

### Added

- Add a rake task to update pd pet/adequacy calcs #3266
- A superadmin can view/edit a list of observation descriptions #3257
- Add 'prescriber' flag to user #3258

### Changed

### Fixed

## 2.0.153

19-06-2020

### Added

### Changed

- Pre-release housekeeping #3251

### Fixed

## 2.0.152

19-06-2020

### Added

### Changed

### Fixed

- Move VERSION constant into a VersionNumber module to resolve loading issues #3250

## 2.0.151

18-06-2020

### Added

- Add per-user mechanism to enable experimental features #3250
- Add Clinical Frailty Score event #3247
- Add Low Clearance Advanced Care Plan event #3247
- Calculate body surface area #3216
- Add Missing ESRF tab to RR preflight checks #3238

### Changed

- NHS number validation checks - spaces and modulus 11 #3224
- Hide wide results in historical path table #3241
- Remove NHS number spaces when sending to UKRDC #3221
- Migrate EQ5D and POS-S surveys to view components #3215
- Enforce one row per patient #3121
- Add organisms to PD dashboard #3226
- Add professional position by prescriber name for HD drugs #3245
- Handle PET and Adequacy separately #3164
- Enforce one unterminated row per patient in renal_profiles, access_profiles, transplant_registrations, modality_modalities #3121

### Fixed

- Fix missing patient 'Once' rules when printing one form at a time #3242
- Fix string < numeric operator error in Age #3214
- Patient-specific results not appearing in on adhoc path req forms #3243

## 2.0.150

16-04-2020

### Added

### Changed

### Fixed

- Session timeout debugging was always on and logging to console #3211

## 2.0.149

14-04-2020

### Added

### Changed

- Changes to support Rails 6 #3210
- Update paper_trail gem and remove deprecation warnings #3209
- Associate UKRDC log entries with a batch #3207

### Fixed

- Ignore validation errors when clearing RPV data at Death #3201

## 2.0.147

30-03-2020

### Added

- List home delivery prescriptions with next delivery date #3174

### Changed

- COVID-19 alert text change #3194
- Display previous modality before death on deceased patients list #3190
- Warn on mailshot form that the entered 'description' will appear on the letter #3187

### Fixed

## 2.0.146

22-03-2020

### Added

### Changed

### Fixed

- Support mailshots #3183

## 2.0.145

17-03-2020

### Added

### Changed

### Fixed

- Fixed bug inserting clinic visit notes into letter body

## 2.0.144

17-03-2020

### Added

### Changed

### Fixed

- Fixed bug inserting snippets into trix editor

## 2.0.143

16-03-2020

### Added

- Add CORVID-19 option when creating a patient alert

### Changed

### Fixed

## 2.0.142

10-03-2020

### Added

### Changed

### Fixed

- Stop HD prescriptions opening in new tab

## 2.0.141

10-03-2020

### Added

### Changed

- Update yarn dependencies #3169

### Fixed

- Minor bug - HD drug prescription #3170

## 2.0.140

09-03-2020

### Added

### Changed

- Home delivery printing refinements #2934

### Fixed

## 2.0.139

04-03-2020

### Added

### Changed

### Fixed

- Fix an error viewing an HD Session

## 2.0.138

03-03-2020

### Added

- Introduce an admin dashboard and LH menu #3135
- Enable switch to es6 using rollup.js #3158
- Introduce pagy gem #3163

### Changed

- Move table/tbody toggling to a stimulus controller #3159

### Fixed

- Drugs given on HD - sign off separate from rest of HD session #3096

## 2.0.137

19-02-2020

### Added

### Changed

### Fixed

- Fixed migration

## 2.0.136

05-02-2020

### Added

### Changed

- Remove user null constraint on pathology group tables #?
- Install pg client 12.1 on CI #3142

### Fixed

## 2.0.135

04-02-2020

### Added

- Add date of death sort on deceased patients table #3080

### Changed

- Limit current access profile query to 1 result #3139

### Fixed

## 2.0.134

04-02-2020

### Added

### Changed

### Fixed

- Revert HD pagination fix - to fix later in data + indexes #3136

## 2.0.133

03-02-2030

### Added

- Add support for data-driven dashboards #3131
- Add ability to search by UKT recipient number #3043
- Add pre HD, post HD, n/a options and weight to BCM #3066
- Start migrating to pathology code groups #3128

### Changed

- User dashboard style change #3037
- Refactor dashboard content into components #3129
- Update UKRDC XSD Schema git submodule #3133
- Allow admins to delete an HD Session #3124
- Improve MDM navigation - MDM links open a new tab #3041
- Coerce HD session blood_flow to int in UKRDC XML #3122

### Fixed

- Fix confusing kaminari pagination issue in HD MDM list #3136
- UKRDC only import a survey file once #3132

## 2.0.132

14-01-2019

### Added

- Add rails 6 support #3114
- Support Ruby 2.7.0 #3102
- Remove stale outgoing XML UKRDC files #3111
- Make consults type a specialty dropdown #3050

### Changed

- UKRDC export performance improvements #3112
- POS-S survey column changes #3075

### Fixed

- Fix spec.rake issue in production #3110
- Handle errors in CalculatePageCountJob #3108

## 2.0.131

07-01-2019

### Added

- Add next of kin text field to demographics #3098
- Add 'patch' and 'sachet' units for medications to default seeds #3100
- Add a hidden column to users #3079

### Changed

- Rename Metrics/LineLength as Layout/LineLength #3105
- Add case insensitive unique index to email and username on users table #3104
- Update actionview component and other dependencies #3103
- Sort ESA prescriptions by modality #3097
- Speed up UKRDC XML rendering using Ox #3091
- Update rails to 5.2.4 #3090
- Add UKRDC configuration to support sending RPV only #3088

### Fixed

## 2.0.130

16-12-2019

### Added

### Changed

### Fixed

- Patient postcode bug - ADT feed #3093

## 2.0.129

13-12-2019

### Added

### Changed

- Low Clearance data - changing 'referred by' to a drop down #3082

### Fixed

- Fix pathology sorting issue on for tests on the same day #3086
- Fix HD protocol table formatting #3085

## 2.0.128

11-12-2019

### Added

### Changed

### Fixed

- Fix HD Session pagation bug #3063

## 2.0.127

10-12-2019

### Added

- Add last 5 dry weights to HD MDM #3045
- Process additional ADT messages #3061
- Display problem notes on Clinical Summary #3047

### Changed

- Use 45 deg angled text in survey table titles #3058
- Add a total score column to POS-S survey table #3057

### Fixed

- Fix survey import issues for POS-S #3059

## 2.0.126

### Added

### Changed

- Display HD drugs administered as a table #2604
- List all patient events and allow them be filtered #2987

### Fixed

## 2.0.125

### Added

### Changed

- Reintroduce ActionView::Component #3052
- Default prescibed_on to today in new prescription form #3049
- Add ability to link to patient from a diary slot #3046

### Fixed

- Hide togglers when printing consults list #3035

## 2.0.124

### Added

- Add button to create new clinic visit from MDM #3029
- Allow deletion of problem notes #3004
- Toggle all rows by clicking an icon in the header #3023

### Changed

- Prevent a modality being added with a future date #3028
- Remember letter author between letters #3022
- Add toggle to body compositions to show notes #3021
- Handle ActiveRecord::PreparedStatementCacheExpired errors during deploy #3011

### Fixed

- Sort HD MDM by access not working #2847
- Skip validation of deceased fields when updating via ADT #3014
- Fix display of erorr pages #3013

## 2.0.123

### Added

### Changed

- Rename ‘Prescribed by’ to ‘Recorded by’ in prescriptions list #3002

### Fixed

- Update nhs_number from ADT messages #3000

## 2.0.122

### Added

- Assign the consultant boolean flag to a user #2997
- Add named consultant in Demographics and in home delivery form #147
- Allow a superadmin to soft-delete an HD Session at any time #2937

### Changed

- Add PTHI and POT columns to HD MDM patients list #2998
- Pathology requests speed up #2996

### Fixed

- Archiving a problem should soft delete its notes #2978

## 2.0.121

### Added

### Changed

### Fixed

- Translate HL7 PID administrative sex to Renalware sex #2992

## 2.0.120

### Added

### Changed

### Fixed

- Fix ADT sex issues

## 2.0.119

### Added

### Changed

### Fixed

- Fix or add debugging for ADT message processing issues

## 2.0.118

### Added

- Allow editing problem notes #2792

### Changed

### Fixed

- Raise the correct error when a duplicate feed mesage is received
- Handle unknown HL7 event codes

## 2.0.117

29-10-2019

### Added

### Changed

### Fixed

- Raise the correct error when a duplicate feed mesage is received

## 2.0.116

28-10-2019

### Added

### Changed

### Fixed

- Revert use of ActionView::Component

## 2.0.115

28-10-2019

### Added

- Introduce ActionView::Component using the LH patient nav as an example #2975
- Pathololgy investigations: add searchable dropdown of OBRs #2918
- Add a colour banner to identify the staging/test env #2819
- Introduce HD Slot Requests #4440

### Changed

- PD Dashboard - limit number of regimes to 5 with option to View All #2814
- Change Renal Profile PRD selection to use the Select2 widget #2972
- Allow html and snippets in access procedure notes #2809
- Disallow free text description when creating or editing a letter #2810
- Pathology Investigations - make RH scrollable area taller #2917

### Fixed

- HD Diary - editing future slot replaces previous ones #2881
- Error filtering letters list by clinic visit clinic id #4444

## 2.0.114

16-10-2019

### Added

- Run webpacker in the renalware-core engine #2963
- Add new LatestCRFOlderThanWeeks rule #2965
- Add consultant boolean flag to users #2959

### Changed

- Restrict further demographics inputs that are controlled by a feed #2964
- Dry weights and BCM on clinical profile - show first 5 #2805

### Fixed

- Pathology request forms performance improvement #2967
- Ensure problems and notes are ordered correctly #2962

## 2.0.113

10-10-2019

### Added

### Changed

### Fixed

- Add engine yarn install during asset precompilation

## 2.0.112

09-10-2019

### Added

- PROMS import #2695
- Allow generating pathology request forms from HD MDM listing #2950

### Changed

- Start moving js assets to Yarn #2949

### Fixed

## 2.0.111

02-10-2019

### Added

- Redirect to dashboard if patient not found #2919
- Display configured hospital address in Home Prescriptions print-out #2932

### Changed

- Limit CMVD results on MDM to 6 most recent #2930
- Add ‘On Worryboard’ to HD session form (‘Protocol’) #2890
- Do not allow an admin to assign the admin role #2916

### Fixed

- Strip and truncate UKRDC ObservationValue to 20 chars #2891
- Catch PG::UniqueViolation on feed_messages #2923
- Address simple_form security vulnerability #2929

## 2.0.110

29-09-2019

### Added

- Rake task to re-apply pd calculations after data migration #2907

### Changed

- Add missing indexes #2913
- Allow searching by any part of drug name #2912
- Switch to a custom UpdateRollingPatientStatisticsJob delayed job class #2908
- Display and filter by consultant in appointments list #2903
- Allow no hospital_identifiers if external_patient_id is present #2893
- Changes to Tx registration status mismatch query #2888

### Fixed

- Fix display bug in pathology request configuration screen #2909
- Fix UKRDC observations to allow for 00:00 time #2902
- Fix missing CMVD pathology on MDMs #2899
- Fix issue adding prescription when using drug category #2898
- Use wicked_pdf_stylesheet_link_tag for css in path request form pdf #2892
- Fix error in GlobalRule where Tx Reg Status is missing #2889
- Fix invalid text representation error when sorting MDMs #2886
- Add priority integer to Admission Consults #2885

## 2.0.109

17-09-2019

### Added

### Changed

### Fixed

- Fix UKRDC Treatment start and stop dates #2883

## 2.0.108

13-09-2019

### Added

### Changed

### Fixed

- Fix UKRDC transplant treatments #2872
- Omit blank and zero observation results in UKRDC XML #2871

## 2.0.107

12-09-2019

### Added

### Changed

- Fix sort order in PD regimes #2835
- Fix HD Profile seeding #2866
- Only include None in the default anticoagulants #2865
- Move anticoagulant#type enum to an I18n file #2864

### Fixed

## 2.0.106

10-09-2019

### Added

### Changed

- Reduce use of with_current_modality_matching #2859
- Add columns to support data migration and feeds #2858

### Fixed

- UKRDC changes #2862

## 2.0.105

08-09-2019

### Added

### Changed

- Change coding standard and codes for observation measurements #2856
- Attempt to speed up UKRDC XML export #2857

### Fixed

## 2.0.104

06-09-2019

### Added

### Changed

- UKRDC changes #2852

### Fixed

## 2.0.103

06-09-2019

### Added

### Changed

- UKRDC changes #2851

### Fixed

## 2.0.102

03-09-2019

### Added

### Changed

- UKRDC changes #2838
- Remove UKRDC medication route description #2854

### Fixed

## 2.0.101

28-08-2019

### Added

### Changed

### Fixed

- UKRDC Missing Dialysis Bloods/Weights/Observations #2775
- Set EnteringOrganization to main site code eg RJZ on Medication elements #2830
- No POST observations reported in XML #2690
- Populate ukrdc prescribing location #2766
- Populate EnteringOrganization in Medication in UKRDC XML #2777

## 2.0.100

27-08-2019

### Added

- Add housekeeping rake task #2763

### Changed

### Fixed

## 2.0.99

23-08-2019

### Added

- Add option on signup for user to request write access

### Changed

### Fixed

## 2.0.98

23-08-2019

### Added

- Add dna and outcome notes columns to appointments #2813
- Add consultants table #2782
- Add legacy_code column to pathology_observation_descriptions #2784

### Changed

- Create new PD regime - start date should be todays date #2791

### Fixed

## 2.0.97

### Added

- Add a configurable ukrdc_pathology_start_date #2781

### Changed

### Fixed

## 2.0.96

### Added

### Changed

### Fixed

- Fix slow UKRDC path query

## 2.0.95

23-07-2019

### Added

### Changed

- UKRDC LabOrder changes #2762
- Change patient ukrdc_external_id type from uuid to string #2760

### Fixed

## 2.0.94

19-07-2019

### Added

### Changed

### Fixed

Fix extraction of rr41 from session#access_type_abbreviation #2756

## 2.0.93

18-07-2019

### Added

### Changed

- UKRDC treatment changes
- GPG encryption changes to avoid use of random_seed file

### Fixed

## 2.0.92

11-07-2019

### Added

### Changed

- UKRDC treatment changes

### Fixed

## 2.0.91

11-07-2019

### Added

### Changed

### Fixed

- Fix UKRDC query to select medications with a numeric dose_amount

## 2.0.90

10-07-2019

### Added

### Changed

- Improve memory handling in UKRDC XML export #2742
- Omit prescriptions in with a non numeric dose amount - UKRDC XML #2741

### Fixed

- UKRDC Treatment refinements #2743

## 2.0.89

### Added

- Output QBL05 for HD Treatments #2736
- UKRDC export - add 'force_send' option #2735

### Changed

### Fixed

## 2.0.88

### Added

### Changed

### Fixed

- Filter out deleted GPs when adding a GP to a patient
- Move database tables to the corect schema.

## 2.0.87

### Added

### Changed

### Fixed

- Fix ODS/zip file permissions access on Linux

## 2.0.86

### Added

### Changed

### Fixed

- Letters const resolution bug in UKRDC export #2722
- ODS CSV import PG path error - use /tmp folder #2724

## 2.0.85

### Added

### Changed

- Add Tx Operations to UKRDC XML #2719

### Fixed

- Omit documents in UKRDC XML for non-RPV patients #2720

## 2.0.84

### Added

- Add Rejection Episodes in Recipient Transplant Followup #2700

### Changed

- Include patients with send_to_renalreg=true in UKRDC XML export #2717

### Fixed

## 2.0.83

### Added

- Transplant Followup - adding graft function onset #2702
- Transplant Followup - record date of last Dialysis post transplant #2703
- Transplant Followup - record date of last Dialysis post transplant #2703
- Haemodialysis session - display Resp Rate in the columns #2711

### Changed

- UKRDC access changes in XML for HD Sessions #2713

### Fixed

## 2.0.82

### Added

### Changed

### Fixed

- Omit UKRDC Treatment ToTime if missing #2708

## 2.0.81

### Added

### Changed

### Fixed

- UKRDC Treatment changes as per schema #2708
- Move position of DeathCause in UKRDC XML #2706

## 2.0.80

### Added

- Generate UKRDC treatments #2685

### Changed

- Send all medications to UKRDC, not just current ones #2699

### Fixed

## 2.0.79

### Added

- Send UKRDC medication dose uom and quantity #2688
- Add a scroll bar to the top of Historical Pathology #2694
- Send comorbidity diagnoses in UKRDC XML #2691
- Add recent consults to bottom of clinical summary #2669
- Add Pre/Post Respiratory Rate to HD Session form #2642
- Enhancements to Virology page #2540
  - add Hepatitis B Core Antibody positive
  - display the latest HepB Surface Antibody titre on virology page
- Sync practice additions/deletions/changes via the NHS API #2696

### Changed

- Update EDTA textual descriptions to match UKRDC #2689
- Make clinic visit form remember the last chosen options #2651

### Fixed

## 2.0.78

### Added

- Add recent clinic visits to all MDMs #2652
- Create AVF/AVG Assessment Tool #2632
- Hide non-printable elements on MDM pages when printing #2663
- Add date of graft nephrectomy to Tx Recipient Followup #2682
- Support multiple configurable subsets of path results for use eg. in MDMs #2664
- Add a ukrdc_modality_codes table #2678

### Changed

- In HD MDM prescriptions section remove the type column #2665
- Make login banner title configurable #2673

### Fixed

- Preserve filters on Consults list when marking one as Done #2671

## 2.0.77

### Added

### Changed

- MR VICTOR changes #2641
- Add dietry protein intake (DPI) to PET Adequacy #2618
- Admin notes not visible after letter approved #1366

### Fixed

## 2.0.76

### Added

### Changed

### Fixed

- UKRDC XML fixes #2658

## 2.0.75

### Added

### Changed

### Fixed

- Fix duplidate LabOrders in UKRDC XML #2631

## 2.0.74

### Added

### Changed

### Fixed

- avoid duplidate LabOrders in UKRDC XML #2630

## 2.0.72

### Added

- HD Session Form - add CRP to Pathology section #2484

### Changed

- Split routes.rb into separate files for each module #2565
- New/edit patient form improvements #2609
- Add updated_at and created_at cols to obx and obr tables #2608
- Create missing OBR and OBX codes dynamically #2607
- Update ruby version used in dev and testing to 2.6.2 #2614

### Fixed

- Toggling clinic visits is ugly when there are html notes #2569

## 2.0.72

### Added

- Add versioning to AKI alerts #2597
- Print home delivery drugs #2315

### Changed

### Fixed

- UKRDC validation fixes #2594

## 2.0.71

### Added

### Changed

### Fixed

- UKRDC XML Change procedure type to Haemodialysis #2583
- UKRDC XML Fix error when there is a missing cause of death #2583

## 2.0.70

### Added

- Support saving an Event to PDF for example to EPR #2573 #2489

### Changed

- Autofocus the first/relevant input on forms #2568
- Prefix top menu urls with renalware.\* to allow link to work while rendering views inside another engine #2566

### Fixed

- Remove empty parentheses next to patient name if they have no NHS number #2568
- Prevent an entry in system_visits on session_timed_out #2547
- Remove n+1 queries in UKRDC XML generation #2541

## 2.0.69

### Added

### Changed

- Housekeeping #2529

### Fixed

## 2.0.68

### Added

- Add ActiveStorage in preparation for adding file attachments to patients #2514

### Changed

- Changes to way Clinical Studies are displayed, in order to prepare for HEROIC #2522
- Convert Study Participants add/edit modal dialog into a full page #2516
- Move address on letter cover sheets down 10mm for Z-folding #2525

### Fixed

## 2.0.67

### Added

### Changed

- Add an HD patient's named nurse as a default electronic CC on new letters #2483
- HD MDM - displaying latest Dry Weight #2459
- On MDM screens add a link, opening in a new tab, to the patient's Prescriptions screen to make
  updating prescriptions easier #2498
- UKRDC changes #2495
  - Add date to LabOrder SpecimenCollectedTime
  - Remove unused elements
  - Remove ContactDetails
- On HD Session form add field for MR VICTOR status (an inspection tool for HD catheter site) #2494
- Update Rails to 5.2.2 #2496
- Housekeeping #2500 #2502 #2499 #2492 #2491 #2488 #2487 #2503
- Sort and paginate user's bookmarks #2506
- Rename 'ESRF / Co-morbidities' menu item to 'Renal Profile' #2505
- Ensure GP practice name appears in practice address in letters #2384
- Add CRP to Recent Pathology in HD Protocol section #2484

### Fixed

## 2.0.66

### Fixed

- Database migration enhancements to support BLT

## 2.0.65

### Fixed

- Extend information stored when logging imported HD Sessions

## 2.0.64

### Fixed

- De-duplicate ccs when archiving a letter.

## 2.0.63

### Changed

- Allow 2 decimal places in weights, to support dialyser data import

## 2.0.62

### Changed

- Letter enhancements

## 2.0.61

### Fixed

- Fixed migration error

## 2.0.60

### Changes

- Letter improvements and additional tests

## 2.0.59

### Changes

- Add a view to aid reporting of incoming HD Sessions

## 2.0.58

### Changes

- Look for 'reporting_daily_xxx' views in any namespace #2473
- Keep development logs small #2472
- Change copyright to 2018 #2468

## 2.0.57

### Changes

- UKRDC XML enhancements

## 2.0.56

### Changes

- UKRDC XML enhancements

## 2.0.55

### Changes

- UKRDC XML enhancements #2463 #2460

## 2.0.55

### Changes

- UKRDC XML filename format changes #2460

## 2.0.54

### Changes

- Changes to the way UKRDC XML files are saved #2456
- Most HD Session HDF fields can now be blank, to allow for Diaverum which does not supply them #2452
- KTV values can not be in the range 0.05 to 3.5 #2452

### Fixed

- In problem lists display the name of the last user to make a change #2452

## 2.0.53

### Fixed

- Report errors in UKRDC rake tasks #2451
- UKRDC XML undefined method 'renal_registry_code' for nil:NilClass #2388

## 2.0.52

08-10-2018

### Added

- Use jemalloc in Heroku review apps to reduce memory usage #2433
- Add Transplant Candidates tab to Low Clearance MDM patients list #1774

### Changed

- Use jemalloc in Heroku review apps to reduce memory usage #2433
- Improvements to Daily Summary Email #2424
- UKRDC XML changes #2445

### Fixed

- Add Practice name to GP addresses on letters #2384
- Fix issue where if > 1 transplant registration status added on the same day,
  the first stays active #2162
- Fix missing patients when sorting Consults by modality #2432
- Security fixes #2420

## 2.0.51

08-10-2018

### Fixed

- Tweaked position of the address in the envelope window when targeting the envelope stuffer

## 2.0.50

08-10-2018

### Fixed

- Remove GP from envelope-stuffer print output if they have already received the letter by email

## 2.0.49

08-10-2018

No change

## 2.0.48

04-10-2018

### Changed

- removed a migration with an index that was taking a long time to build

## 2.0.47

04-10-2018

### Added

- Support generating printable output compatible with an envelope stuffer #2382
- Sort and filter Renal Reg pre-flight checks by HD Site #2101
- Upgrade rails to 5.2.1 #2247
- Toggle HD session notes in HD session listing #2401
- Disallow adding a patient with no hospital or NHS no #2217
- Filter and tab design improvements #2400
- Toggle clinic visit notes on Clinic Visits list #2395
- Sorting on Tx Status in Low Clearance MDM patients list #2389
- Prevent unapproved users from being new Message or eCC recipients #2403
- Highlight banner patient number when clicked on #2165

### Changed

- Handle deleting a ward that is in use #2367

### Fixed

- Daily summary email not sending #2392
- Daily summary reports not always created in the renalware namespace
- Deceased patients continue to age #2394

## 2.0.46

21-09-2018

### Changed

- Only pass the FeedMessage when broadcasting message_processed event #2391

## 2.0.45

21-09-2018

### Added

- Support async Wisper subscribers #2381
- Support sending a daily summary email #2373

### Changed

- Encrypt UKRDC XML files automatically before sending #2386
- Add 'Patient Refused' vaccination type
- Prepare for Rails 5.2 #2372 #2376 #2375 #2377

### Fixed

- Should include both approved and completed letters in UKRDC export #2387
- HD audit view does not refresh after monthly report generation #2378

## 2.0.44

29-08-2018

### Added

### Changed

- Improve delayed job performance #2370

### Fixed

- Entering an integer into the Patient Search field causes an error #2364
- PD Assessment date validation #2366
- Transmission log fix #2363

## 2.0.43

17-08-2018

### Added

### Changed

- Improved AKI Alerts ward display

### Fixed

## 2.0.42

16-08-2018

### Added

- Support for HD providers like Diaverum and Fresenius #2307
- Allow listing Aki Alerts by date #2248
- Add % fistula or graft to HD Overall audit #2357

### Changed

### Fixed

- Patient search sort order order wrong when results contain a mix upper and lower case family names #2200
- PatientSearch is intercepting ransack searches if params[:q] present #2316
- Add StudyParticipantsController#show action #2358
- Fix KCH letter create error #2356

## 2.0.41

14-08-2018

### Added

- Manually create a clinic appointment #2343

### Changed

### Fixed

## 2.0.40

08-08-2018

### Added

- On HD Session form display users who signed-on and off the session #2342
- Add HTLV to Virology Profile #2341
- Add Supportive Care filter to Low Clearance MDM patients listing #2332
- Add HD Schedule filter (eg MWF, MWF AM, etc) to HD MDM patients listing #2074
- Add MDM sorting by access plan type, plan date, current access and transplant registration status #2337
- Ability to see Problem list and Medications whilst composing a letter #2090
- LCC MDM screen virology additions #2303

### Changed

### Fixed

- Correct the dashboard default sorting #2263

## 2.0.39

16-07-2018

### Fixed

### Added

- Ability to hide a modality so it cannot be added to a patient #2318
- Ability to view all bookmarks #2324
- Added events to bottom of all MDMs #2323
- Add Additional Info section to a PD MDM #2322

### Changed

## 2.0.38

10-07-2018

### Fixed

### Added

- Add Additional Information section to HD MDM
- Add ESRF date and modality filters to Renal Reg pre-flight checks

### Changed

- Strip white space around JSONB documents

## 2.0.37

28-06-2018

### Fixed

- letter sort order

## 2.0.36

28-06-2018

### Added

- Added letterhead filter on Renal Letters page

### Changed

- Strip whitespace around numerics when saving jsonb documents
- Add PerRectum medication route to demo data

### Fixed

- Prescriptions now sort by drug name then prescription date descending
- Letters now sort by the date they were moved into their correct state (e.g. Approved)
- Fix UKRDC XML issues
- Fix patient demographics layout where telephone and email labels not aligning

## 2.0.35

21-06-2018

### Added

### Changed

### Fixed

- UKRDC export updates patient.sent_to_ukrdc_at date correctly

## 2.0.34

21-06-2018

### Added

### Changed

### Fixed

- Ordering of letters in lists

## 2.0.33

19-06-2018

### Added

### Changed

- When displaying tables of letters, make the Date column the date+time when the letter was edited
- When displaying tables of letters, display most recently updated letters at the top
  except on the user's dashboard where the order is reversed
- Add membrane_surface_area and membrane_surface_area_coefficient_k0a columns to HD Dialysers
- Add bicarbonate_content etc columns to HD Dialysates

### Fixed

- Do not output patient language in UKRDC XML if it is "Unknown"

## 2.0.32

14-06-2018

### Added

### Changed

- Updated Low Clearance profile dialysis plan dropdown options

### Fixed

## 2.0.31

07-06-2018

### Fixed

- Fixed caching bug where research study participation alerts were not invalidating
  when the study's application_url or name was changed.

## 2.0.30

07-06-2018

### Fixed

- Fixed an issue preventing migration of SQL functions in host app

## 2.0.29

06-06-2018

### Added

### Changed

- Support linking to external clinical study applications, including passing a new
  pseudo-anonymised participant id

### Fixed

- HD Sessions stamped with the wrong dry_weight (first not latest)

## 2.0.28

31-05-2018

### Added

### Changed

- UKRDC XML changes

### Fixed

- Disallow duplicate OBX and OBR codes

## 2.0.27

21-05-2018

### Added

### Changed

### Fixed

- Fixed bug in BP validation where systolic or diastolic contains spaces #2260
- Fixed bug loading a form where an underlying jsonb date is invalid #2259

## 2.0.26

21-05-2018

### Added

- Ward management
- `patient_current modalities` view to make querying patients by modality easier

### Changed

- Raise custom error if OBX or OBR code not found, so we can see the missing code

### Fixed

- Bug searching consults using e.g. `rabbit r`
- Fix letter layout when excluding pathology as instructed by the letterhead in use
- Fix blank screen (InvalidAuthicityToken error) when logging in after a after a
  javascript session timeout

## 2.0.25

08-05-2018

### Added

### Changed

- Display ward name and code in AKI alerts
- Add hotlist tab to AKI Alerts
- Prevent duplicate HL7 messages being imported #2244
- Use headless chrome for testing #2243
- Improve AKI Alert printing #2241
- Improve Consult printing #2240
- Display space for user putting on/taking off on HD Protocol #2145
- Filter consults by RRT #2242
- Add notes to Transplant Waitlist Registration #1854

### Fixed

## 2.0.24

08-05-2018

### Added

### Changed

### Fixed

- Allow a GP to be added to a patient with incomplete demographics.
- Topup API error

## 2.0.23

03-05-2018

### Added

### Changed

- Its now possible to generate HD monthly audits for specific year and month

### Fixed

- When a patient dies, terminate only current prescriptions and do not change the termination
  dates of previously terminated ones

## 2.0.22

02-05-2018

### Added

- Add an warning to the New Patient form to ask the user to check the patient does not already exist
- Add HIV HepB HepC to Virology Profile

### Changed

- Local patient ids (hospital numbers) should be unique (currently validating at the application but
  not the db level).

### Fixed

- Supply defaults of UNKNOWN and today's date if HL7 requestor name or date are blank
- Occasional incorrect format of letter rows in tables
- Fix unresolved MonthPeriod constant generating HD Monthly audits

## 2.0.20

27-04-2018

### Added

### Changed

- HD Overall Audit enhancements
- AKI Audit UI tweaks
- Admission Consults UI tweaks

### Fixed

- UKRDC rake task accepts an optional list of patient ids correctly

## 2.0.19

26-04-2018

### Added

### Changed

- Add check in PracticeMailer that the letter is completed or approved
- No longer rounds new Event date times to the nearest hour

### Fixed

- Removed unnecessary check that a letter has a practice in PracticeMailer which was causing
  letters for a patient without a practice to fail when sent to QEH admin email.
- When sending letters using PracticeMailer, cast to a super class otherwise if the letter state
  (and STI class) moves on the letter will not be found by the background worker.

## 2.0.18

24-04-2018

### Added

- Allow searching users by email address

### Changed

- Allow a host app to supply an exception notifier instance via Renalware::Engine#exception_notifier
  which will be used to log errors in non-ActiveJob and non-ApplicationMailer delayed jobs.

### Fixed

- Remove unused :recipient argument in PracticeMailer which was causing an error at KCH.
- Fix `unresolved NullObject` error in routes by supplying an instance of the new NullUser class.

## 2.0.17

23-04-2018

### Added

- UI for managing feedback

### Changed

- Improve consults seeding in demo
- Update Rails to version 5.1.6
- Added sorting by modality in Wait List
- Changed wording in HD Session for to Put On By and Taken Off By

### Fixed

- Prevent deletion of completed letters
- Correct algorithm for calculating mean_ufr in HD audit
- Fixed CAPD glucose calculations when a bag's type changes

## 2.0.16

18-04-2018

### Added

### Changed

- Display HD Site in TX Wait List
- Display patient name to user's letters list
- Display HD Site in patient banner
- Removed unused code ad routes

### Fixed

- Fixed #2160 Unread eCCs now only visible (and be marked as read) for approved and completed letters
- Fixed #2168 String comparison with zero error creating hd_statistics row

## 2.0.15

06-04-2018

### Added

### Changed

- Make the HD Session Save button grey
- Improve AKIAlert demo seeding

### Fixed

- Use created_at for the AKIAlert today scope

## 2.0.14

06-04-2018

### Added

- AKI Alerts Today and All tabs on index view
- Index view to patents API
- Rake task to allow a developer to sign off stale sessions

### Changed

- Removed CRE value and date columns from AKI Alerts table

### Fixed

## 2.0.13

05-04-2018

### Added

### Changed

- Add validation to HD Session to prevent non-numeric data being entered which affects auditing
- Change layout of recently changed medications in letters and medications print-out

### Fixed

- display any telephone or email associated wth a patients address in addition t
  o the those attached to the patient

## 2.0.12

29-03-2018

### Added

- Rake task to refresh all materialized views

### Changed

- In letters, patient and contact address parts have their own line rather than having
  town county postcode on the last line
- Make patient_id required in Transplant Recipient Operations table

### Fixed

- Printing consults list #2081
- 'myocardial_infarction typo' in transplant recipient operations
- Default sort in Internal Messages
- Corrected default sort order of prescriptions in MDMs
- Fixed an error viewing demographics when patient is deceased but has no first cause
- Corrected display of recent pathology results in letters

## 2.0.11

23-03-2018

### Added

- Added latest dry weight to HD Protocol

### Changed

### Fixed

- Error approving a letter with an address with no postcode

## 2.0.10

22-03-2018

### Added

- Display VIA EMAIL to xxx is recipient/cc is a GP and patient's practice has an email address

## 2.0.9

22-03-2018

### Added

### Changed

### Fixed

- Female default name prefix changed from Mme to Ms
- Use patient title in patient summary in letters
- Fixed default sort order in user's letters list
- Fixed sorting by eg HGB result in MDM patients lists
- Fixed HD Audit delayed job error failing with non-numeric path results
- Remove misplaced Dear in front of GP addresses in letters
- Increase padding below CC: heading in letters

## 2.0.8

19-03-2018

### Added

- Added 'Tx in Past Year' filter to Tx MDM listing
- Display Practice telephone and email in patient demographics

### Changed

- Added PCR and ACR to Current Investigations

### Fixed

- Remove 'Barts and London' title from printed Medications list
- Sorting by OBX result in MDM lists where there are non-numeric results
- Added 'Yours sincerely' to letters
- Allow soft delete of consults with no consult_type in migrated data
- Fixed letter error when is GP but Practice (patient main recipient radio not selected by default)

## 2.0.7

16-03-2018

### Added

### Changed

- Increase spacing between CCs on letters
- Consults: better filtering and searching
- Enlarge Problems text entry box

### Fixed

- Footer on error pages now sticky
- Alert partial missing error
- Snippets modal and snippets management page are now scrollable and html content doesn't wrap
- HD MDM change_in errors when post measurement is a string that cannot be coerced into a number
- Correct the set of practices imported from TRUD

## 2.0.6

14-03-2018

### Added

### Changed

### Fixed

- Correct salutation on newly added letter contact
- Remove use of address.name which was causing blank addresses in letters
- Import practices with organisation role RO177 as well as RO76
- Compact the New Contact dialog so it fits on the screen

## 2.0.5

13-03-2018

### Added

### Changed

### Fixed

- Error displaying change_in values in HD Sessions table when measurement are not numeric

## 2.0.4

13-03-2018

### Added

### Changed

- Removed unnecessary validations on Transplant Recipient Operation
- Removed unnecessary validations on HD (Closed) Session

### Fixed

- Admission Consults uses ended_on date not deleted_at for determining active status

## 2.0.3

13-03-2018

### Added

- Filters on consults
- Optional signup_help partial

### Changed

### Fixed

## 2.0.2

12-03-2018

### Added

### Changed

### Fixed

- Always use practice address when sending to GP
- Resolve missing patient CC on letters

## 2.0.1

11-03-2018

### Added

### Changed

- Make OBR requestor_order_number nil if blank
- Ensure uniqueness of OBR requestor_order_number

### Fixed

## 2.0.0

09-03-2018

### Added

- Display an alert if the user is in a clinical study
- Track page views and logins

### Changed

- Support overriding the login warning messages
- Make OBR requestor_order_number unique
- Filter and search AKI alerts
- Add pagination to research studies
- Update Investigation types codes

### Fixed

- Display correct html event notes when toggling events content
- CSS display in Chrome, remove excessive padding at page bottom
- Use UTF8 in PDFs

## 2.0.0.pre.rc12

06-03-2018

### Added

- Use a modal to ask if letter should be marked as printed (ie completed) after printing

### Changed

- Capture the who and when of letter state changes
- Use new database columns to restrict and order the pathology observations to display
- Introduce frozen_string_literal comment in presenters, spec and cucumber features.
  Roll out across the rest of the app later.
- Add Prescriptions to the API

### Fixed

- Removed rogue column in aki_alerts
- FireFox layout fix - we now use flexbox CSS on patient pages
- Remove Print All button on Renal -> Letters. It didn't do anything.
- Use a transaction around HL7 processing to prevent orphaned observations and
  observation_requests if once of the OBXs fails (causing a delayed_job retry).

## 2.0.0.pre.rc12

27-02-2018

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

21-02-2018

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

13-02-2018

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

07-02-2018 - Created to debug gem resolution issue.

## 2.0.0.pre.rc8

06-02-2018

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

29-01-2018

### Added

### Changed

- Email handling when letter approved

### Fixed

## 2.0.0.pre.rc7

29-01-2018

### Added

- Patient Investigations

### Changed

- UKRDC XML changes
- don't display path results on letter if letterhead forbids it

### Fixed

- support HL7 messages with > 1 OBR segment
- set updated_at on pathology_current_observation_sets when jsonb is updated with a new result

## 2.0.0.pre.rc6

16-01-2018

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

16-01-2018

### Added

- GP and Practice import via file

### Changed

### Fixed

- Minor bug fixes

## 2.0.0.pre.rc4

16-01-2018

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
