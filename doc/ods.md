# Synchronising practices and GPs with NHS ODS

Renalware stores Organisation Data Service (ODS) data in:

```text
patient_practices                 prescribing cost centres and GP practices
patient_primary_care_physicians   GPs
patient_practice_memberships      GP-to-practice memberships
```

The scheduled `Renalware::Patients::SyncODSJob` runs daily at 6am. It downloads three full CSV
reports from NHS ODS Data Search and Export (DSE), validates every row, and then imports all three
reports in one database transaction:

1. `epraccur` - prescribing cost centres, including GP practices
2. `egpcur` - GPs
3. `epracmem` - GP-to-practice memberships

DSE refreshes its source data nightly. The report endpoints are:

```text
https://www.odsdatasearchandexport.nhs.uk/api/getReport?report=epraccur
https://www.odsdatasearchandexport.nhs.uk/api/getReport?report=egpcur
https://www.odsdatasearchandexport.nhs.uk/api/getReport?report=epracmem
```

The legacy TRUD Weekly Prescribing Data pack and the corresponding `files.digital.nhs.uk` ZIP
downloads were retired in 2025. Renalware no longer uses the ODS ORD API for this sync.

## Running the sync

Enqueue a normal sync with:

```bash
bundle exec rake ods:sync
```

The rake task enqueues a background job, so a job worker must be running.

Run the complete download, validation, and import as a dry run with:

```bash
dry_run=true bundle exec rake ods:sync
```

A dry run performs all reconciliation work and records the proposed counts in `system_api_logs`,
but rolls back the database changes.

## Safety and reconciliation

All three reports are downloaded and validated before the transaction starts. Each report must:

- return HTTP success with a CSV content type
- contain the expected number of columns on every row
- exceed a conservative minimum row count, protecting against truncated or empty snapshots
- remain within 15% of the previous successful source row count

Membership rows must reference a GP and practice present in their corresponding master reports.
Unknown codes fail the complete transaction and the error reports counts and sample codes.

### Reconciliation rules

Practices and GPs are upserted by their ODS code. An explicit inactive practice status marks the
practice inactive, and an explicit inactive or retired GP status soft-deletes the GP. A practice or
GP omitted from its master report retains its existing local state; absence alone is not treated as
evidence that it has closed or retired.

Membership state follows these rules:

- A membership is active when its GP is active and `left_on` is blank, today, or in the future.
- `left_on` is inclusive: the membership becomes inactive on the first sync after that date.
- A future `joined_on` does not delay activation.
- An inactive practice may retain active GP memberships.
- A membership reported for an inactive or retired GP is retained but marked inactive.
- An ODS-managed membership omitted from `epracmem` is soft-deleted. It is restored if it later
  reappears.
- Locally managed and default memberships are not removed by snapshot cleanup.
- The local Generic GP (`G9999998`) and every membership pointing to it are never changed by the
  ODS import, even if DSE supplies rows using that code.

Rows imported from ODS have `ods_managed = true`. These provenance flags distinguish records that
can be reconciled from the full snapshot from records managed locally in Renalware.

Each attempt creates a `system_api_logs` row under the `nhs_ods_dse` identifier. Failures include
the exception and backtrace. Download and report-validation failures are retried three times.

## Manual file imports

The feed administration UI still supports manual `egpcur` and `epracmem` imports. It accepts the
plain CSV reports downloaded from DSE as well as legacy ZIP archives retained for recovery or
historical use.

## Migration notes

Practices and GPs should be synced before importing patient data. A patient's `practice_id` and
`primary_care_physician_id` are foreign keys, so external ODS codes must first be resolved against
`patient_practices.code` and `patient_primary_care_physicians.code`.

Letters are sent to the practice address rather than the GP address. This is intentional because a
GP may move practice before the patient's recorded GP is updated.

See the NHS England [GP and GP practice related data](https://digital.nhs.uk/services/organisation-data-service/data-search-and-export/csv-downloads/gp-and-gp-practice-related-data)
page for report specifications and service guidance.
