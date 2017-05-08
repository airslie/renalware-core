# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170608192234) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "access_assessments", force: :cascade do |t|
    t.integer  "patient_id"
    t.integer  "type_id",       null: false
    t.integer  "site_id",       null: false
    t.string   "side",          null: false
    t.date     "performed_on",  null: false
    t.date     "procedure_on"
    t.text     "comments"
    t.integer  "created_by_id", null: false
    t.integer  "updated_by_id", null: false
    t.jsonb    "document"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["created_by_id"], name: "index_access_assessments_on_created_by_id", using: :btree
    t.index ["document"], name: "index_access_assessments_on_document", using: :gin
    t.index ["patient_id"], name: "index_access_assessments_on_patient_id", using: :btree
    t.index ["site_id"], name: "index_access_assessments_on_site_id", using: :btree
    t.index ["type_id"], name: "index_access_assessments_on_type_id", using: :btree
    t.index ["updated_by_id"], name: "index_access_assessments_on_updated_by_id", using: :btree
  end

  create_table "access_catheter_insertion_techniques", force: :cascade do |t|
    t.string   "code",        null: false
    t.string   "description", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "access_plans", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "access_procedures", force: :cascade do |t|
    t.integer  "patient_id"
    t.integer  "type_id",                            null: false
    t.integer  "site_id"
    t.string   "side"
    t.date     "performed_on",                       null: false
    t.boolean  "first_procedure"
    t.string   "catheter_make"
    t.string   "catheter_lot_no"
    t.text     "outcome"
    t.text     "notes"
    t.date     "first_used_on"
    t.date     "failed_on"
    t.integer  "created_by_id",                      null: false
    t.integer  "updated_by_id",                      null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "performed_by"
    t.integer  "pd_catheter_insertion_technique_id"
    t.index ["created_by_id"], name: "index_access_procedures_on_created_by_id", using: :btree
    t.index ["patient_id"], name: "index_access_procedures_on_patient_id", using: :btree
    t.index ["pd_catheter_insertion_technique_id"], name: "access_procedure_pd_catheter_tech_idx", using: :btree
    t.index ["site_id"], name: "index_access_procedures_on_site_id", using: :btree
    t.index ["type_id"], name: "index_access_procedures_on_type_id", using: :btree
    t.index ["updated_by_id"], name: "index_access_procedures_on_updated_by_id", using: :btree
  end

  create_table "access_profiles", force: :cascade do |t|
    t.integer  "patient_id"
    t.date     "formed_on",     null: false
    t.date     "planned_on"
    t.date     "started_on"
    t.date     "terminated_on"
    t.integer  "type_id",       null: false
    t.integer  "site_id",       null: false
    t.integer  "plan_id"
    t.string   "side",          null: false
    t.text     "notes"
    t.integer  "created_by_id", null: false
    t.integer  "updated_by_id", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "decided_by_id"
    t.index ["created_by_id"], name: "index_access_profiles_on_created_by_id", using: :btree
    t.index ["decided_by_id"], name: "index_access_profiles_on_decided_by_id", using: :btree
    t.index ["patient_id"], name: "index_access_profiles_on_patient_id", using: :btree
    t.index ["plan_id"], name: "index_access_profiles_on_plan_id", using: :btree
    t.index ["site_id"], name: "index_access_profiles_on_site_id", using: :btree
    t.index ["type_id"], name: "index_access_profiles_on_type_id", using: :btree
    t.index ["updated_by_id"], name: "index_access_profiles_on_updated_by_id", using: :btree
  end

  create_table "access_sites", force: :cascade do |t|
    t.string   "code",       null: false
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "access_types", force: :cascade do |t|
    t.string   "code",         null: false
    t.string   "name",         null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "abbreviation"
  end

  create_table "access_versions", force: :cascade do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.jsonb    "object"
    t.jsonb    "object_changes"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "access_versions_type_id", using: :btree
  end

  create_table "addresses", force: :cascade do |t|
    t.string   "addressable_type",  null: false
    t.integer  "addressable_id",    null: false
    t.string   "street_1"
    t.string   "street_2"
    t.string   "county"
    t.string   "city"
    t.string   "postcode"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "country"
    t.string   "name"
    t.string   "organisation_name"
    t.string   "telephone"
    t.string   "email"
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable_type_and_addressable_id", using: :btree
  end

  create_table "clinic_appointments", force: :cascade do |t|
    t.datetime "starts_at",        null: false
    t.integer  "patient_id",       null: false
    t.integer  "user_id",          null: false
    t.integer  "clinic_id",        null: false
    t.integer  "becomes_visit_id"
    t.index ["clinic_id"], name: "index_clinic_appointments_on_clinic_id", using: :btree
    t.index ["patient_id"], name: "index_clinic_appointments_on_patient_id", using: :btree
    t.index ["user_id"], name: "index_clinic_appointments_on_user_id", using: :btree
  end

  create_table "clinic_clinics", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id",    null: false
    t.index ["user_id"], name: "index_clinic_clinics_on_user_id", using: :btree
  end

  create_table "clinic_versions", force: :cascade do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.jsonb    "object"
    t.jsonb    "object_changes"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "clinic_versions_type_id", using: :btree
  end

  create_table "clinic_visits", force: :cascade do |t|
    t.integer  "patient_id"
    t.date     "date",                                                          null: false
    t.float    "height"
    t.float    "weight"
    t.integer  "systolic_bp"
    t.integer  "diastolic_bp"
    t.string   "urine_blood"
    t.string   "urine_protein"
    t.text     "notes"
    t.integer  "created_by_id",                                                 null: false
    t.integer  "updated_by_id",                                                 null: false
    t.datetime "created_at",                                                    null: false
    t.datetime "updated_at",                                                    null: false
    t.integer  "clinic_id",                                                     null: false
    t.time     "time"
    t.text     "admin_notes"
    t.integer  "pulse"
    t.boolean  "did_not_attend",                                default: false, null: false
    t.decimal  "temperature",           precision: 3, scale: 1
    t.integer  "standing_systolic_bp"
    t.integer  "standing_diastolic_bp"
    t.index ["clinic_id"], name: "index_clinic_visits_on_clinic_id", using: :btree
    t.index ["created_by_id"], name: "index_clinic_visits_on_created_by_id", using: :btree
    t.index ["patient_id"], name: "index_clinic_visits_on_patient_id", using: :btree
    t.index ["updated_by_id"], name: "index_clinic_visits_on_updated_by_id", using: :btree
  end

  create_table "clinical_allergies", force: :cascade do |t|
    t.integer  "patient_id",    null: false
    t.text     "description",   null: false
    t.datetime "recorded_at",   null: false
    t.datetime "deleted_at"
    t.integer  "created_by_id", null: false
    t.integer  "updated_by_id", null: false
    t.index ["created_by_id"], name: "index_clinical_allergies_on_created_by_id", using: :btree
    t.index ["patient_id"], name: "index_clinical_allergies_on_patient_id", using: :btree
    t.index ["updated_by_id"], name: "index_clinical_allergies_on_updated_by_id", using: :btree
  end

  create_table "clinical_dry_weights", force: :cascade do |t|
    t.integer  "patient_id"
    t.float    "weight",        null: false
    t.date     "assessed_on",   null: false
    t.integer  "created_by_id", null: false
    t.integer  "updated_by_id", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "assessor_id",   null: false
    t.index ["assessor_id"], name: "index_clinical_dry_weights_on_assessor_id", using: :btree
    t.index ["created_by_id"], name: "index_clinical_dry_weights_on_created_by_id", using: :btree
    t.index ["patient_id"], name: "index_clinical_dry_weights_on_patient_id", using: :btree
    t.index ["updated_by_id"], name: "index_clinical_dry_weights_on_updated_by_id", using: :btree
  end

  create_table "clinical_versions", force: :cascade do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.jsonb    "object"
    t.jsonb    "object_changes"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_clinical_versions_on_item_type_and_item_id", using: :btree
  end

  create_table "death_edta_codes", force: :cascade do |t|
    t.integer  "code"
    t.string   "death_cause"
    t.datetime "deleted_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "directory_people", force: :cascade do |t|
    t.string   "given_name",    null: false
    t.string   "family_name",   null: false
    t.string   "title"
    t.integer  "created_by_id", null: false
    t.integer  "updated_by_id", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["created_by_id"], name: "index_directory_people_on_created_by_id", using: :btree
    t.index ["updated_by_id"], name: "index_directory_people_on_updated_by_id", using: :btree
  end

  create_table "drug_types", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "code",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "drug_types_drugs", id: false, force: :cascade do |t|
    t.integer "drug_id"
    t.integer "drug_type_id"
    t.index ["drug_id", "drug_type_id"], name: "index_drug_types_drugs_on_drug_id_and_drug_type_id", unique: true, using: :btree
  end

  create_table "drugs", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "event_types", force: :cascade do |t|
    t.string   "name",             null: false
    t.datetime "deleted_at"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "event_class_name"
    t.string   "slug"
    t.index ["slug"], name: "index_event_types_on_slug", unique: true, using: :btree
  end

  create_table "events", force: :cascade do |t|
    t.integer  "patient_id",    null: false
    t.datetime "date_time",     null: false
    t.integer  "event_type_id"
    t.string   "description"
    t.text     "notes"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "created_by_id", null: false
    t.integer  "updated_by_id", null: false
    t.string   "type",          null: false
    t.jsonb    "document"
    t.index ["created_by_id"], name: "index_events_on_created_by_id", using: :btree
    t.index ["event_type_id"], name: "index_events_on_event_type_id", using: :btree
    t.index ["patient_id"], name: "index_events_on_patient_id", using: :btree
    t.index ["type"], name: "index_events_on_type", using: :btree
    t.index ["updated_by_id"], name: "index_events_on_updated_by_id", using: :btree
  end

  create_table "feed_messages", force: :cascade do |t|
    t.string   "event_code", null: false
    t.string   "header_id",  null: false
    t.text     "body",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hd_cannulation_types", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hd_dialysers", force: :cascade do |t|
    t.string   "group",      null: false
    t.string   "name",       null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hd_patient_statistics", force: :cascade do |t|
    t.integer  "patient_id",                                                                         null: false
    t.integer  "hospital_unit_id",                                                                   null: false
    t.integer  "month"
    t.integer  "year"
    t.boolean  "rolling"
    t.decimal  "pre_mean_systolic_blood_pressure",              precision: 10, scale: 2
    t.decimal  "pre_mean_diastolic_blood_pressure",             precision: 10, scale: 2
    t.decimal  "post_mean_systolic_blood_pressure",             precision: 10, scale: 2
    t.decimal  "post_mean_diastolic_blood_pressure",            precision: 10, scale: 2
    t.decimal  "lowest_systolic_blood_pressure",                precision: 10, scale: 2
    t.decimal  "highest_systolic_blood_pressure",               precision: 10, scale: 2
    t.decimal  "mean_fluid_removal",                            precision: 10, scale: 2
    t.decimal  "mean_weight_loss",                              precision: 10, scale: 2
    t.decimal  "mean_machine_ktv",                              precision: 10, scale: 2
    t.decimal  "mean_blood_flow",                               precision: 10, scale: 2
    t.decimal  "mean_litres_processed",                         precision: 10, scale: 2
    t.datetime "created_at",                                                                         null: false
    t.datetime "updated_at",                                                                         null: false
    t.integer  "session_count",                                                          default: 0, null: false
    t.integer  "number_of_missed_sessions"
    t.integer  "dialysis_minutes_shortfall"
    t.decimal  "dialysis_minutes_shortfall_percentage",         precision: 10, scale: 2
    t.decimal  "mean_ufr",                                      precision: 10, scale: 2
    t.decimal  "mean_weight_loss_as_percentage_of_body_weight", precision: 10, scale: 2
    t.index ["hospital_unit_id"], name: "index_hd_patient_statistics_on_hospital_unit_id", using: :btree
    t.index ["month"], name: "index_hd_patient_statistics_on_month", using: :btree
    t.index ["patient_id", "month", "year"], name: "index_hd_patient_statistics_on_patient_id_and_month_and_year", unique: true, using: :btree
    t.index ["patient_id", "rolling"], name: "index_hd_patient_statistics_on_patient_id_and_rolling", unique: true, using: :btree
    t.index ["patient_id"], name: "index_hd_patient_statistics_on_patient_id", using: :btree
    t.index ["rolling"], name: "index_hd_patient_statistics_on_rolling", using: :btree
    t.index ["year"], name: "index_hd_patient_statistics_on_year", using: :btree
  end

  create_table "hd_preference_sets", force: :cascade do |t|
    t.integer  "patient_id",       null: false
    t.integer  "hospital_unit_id"
    t.string   "schedule"
    t.string   "other_schedule"
    t.date     "entered_on"
    t.text     "notes"
    t.integer  "created_by_id",    null: false
    t.integer  "updated_by_id",    null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["created_by_id"], name: "index_hd_preference_sets_on_created_by_id", using: :btree
    t.index ["hospital_unit_id"], name: "index_hd_preference_sets_on_hospital_unit_id", using: :btree
    t.index ["patient_id"], name: "index_hd_preference_sets_on_patient_id", using: :btree
    t.index ["updated_by_id"], name: "index_hd_preference_sets_on_updated_by_id", using: :btree
  end

  create_table "hd_prescription_administrations", force: :cascade do |t|
    t.integer  "hd_session_id",   null: false
    t.integer  "prescription_id", null: false
    t.boolean  "administered"
    t.text     "notes"
    t.integer  "created_by_id",   null: false
    t.integer  "updated_by_id",   null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["created_by_id"], name: "index_hd_prescription_administrations_on_created_by_id", using: :btree
    t.index ["hd_session_id"], name: "index_hd_prescription_administrations_on_hd_session_id", using: :btree
    t.index ["prescription_id"], name: "index_hd_prescription_administrations_on_prescription_id", using: :btree
    t.index ["updated_by_id"], name: "index_hd_prescription_administrations_on_updated_by_id", using: :btree
  end

  create_table "hd_profiles", force: :cascade do |t|
    t.integer  "patient_id"
    t.integer  "hospital_unit_id"
    t.string   "schedule"
    t.string   "other_schedule"
    t.integer  "prescribed_time"
    t.date     "prescribed_on"
    t.integer  "created_by_id",                       null: false
    t.integer  "updated_by_id",                       null: false
    t.jsonb    "document"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "prescriber_id"
    t.integer  "named_nurse_id"
    t.integer  "transport_decider_id"
    t.datetime "deactivated_at"
    t.boolean  "active",               default: true
    t.index ["active", "patient_id"], name: "index_hd_profiles_on_active_and_patient_id", unique: true, using: :btree
    t.index ["created_by_id"], name: "index_hd_profiles_on_created_by_id", using: :btree
    t.index ["document"], name: "index_hd_profiles_on_document", using: :gin
    t.index ["hospital_unit_id"], name: "index_hd_profiles_on_hospital_unit_id", using: :btree
    t.index ["named_nurse_id"], name: "index_hd_profiles_on_named_nurse_id", using: :btree
    t.index ["patient_id"], name: "index_hd_profiles_on_patient_id", using: :btree
    t.index ["prescriber_id"], name: "index_hd_profiles_on_prescriber_id", using: :btree
    t.index ["transport_decider_id"], name: "index_hd_profiles_on_transport_decider_id", using: :btree
    t.index ["updated_by_id"], name: "index_hd_profiles_on_updated_by_id", using: :btree
  end

  create_table "hd_sessions", force: :cascade do |t|
    t.integer  "patient_id"
    t.integer  "hospital_unit_id"
    t.integer  "modality_description_id"
    t.date     "performed_on",            null: false
    t.time     "start_time"
    t.time     "end_time"
    t.integer  "duration"
    t.text     "notes"
    t.integer  "created_by_id",           null: false
    t.integer  "updated_by_id",           null: false
    t.jsonb    "document"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "signed_on_by_id"
    t.integer  "signed_off_by_id"
    t.string   "type",                    null: false
    t.datetime "signed_off_at"
    t.integer  "profile_id"
    t.integer  "dry_weight_id"
    t.index ["created_by_id"], name: "index_hd_sessions_on_created_by_id", using: :btree
    t.index ["document"], name: "index_hd_sessions_on_document", using: :gin
    t.index ["dry_weight_id"], name: "index_hd_sessions_on_dry_weight_id", using: :btree
    t.index ["hospital_unit_id"], name: "index_hd_sessions_on_hospital_unit_id", using: :btree
    t.index ["id", "type"], name: "index_hd_sessions_on_id_and_type", using: :btree
    t.index ["modality_description_id"], name: "index_hd_sessions_on_modality_description_id", using: :btree
    t.index ["patient_id"], name: "index_hd_sessions_on_patient_id", using: :btree
    t.index ["profile_id"], name: "index_hd_sessions_on_profile_id", using: :btree
    t.index ["signed_off_by_id"], name: "index_hd_sessions_on_signed_off_by_id", using: :btree
    t.index ["signed_on_by_id"], name: "index_hd_sessions_on_signed_on_by_id", using: :btree
    t.index ["updated_by_id"], name: "index_hd_sessions_on_updated_by_id", using: :btree
  end

  create_table "hd_versions", force: :cascade do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.jsonb    "object"
    t.jsonb    "object_changes"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "hd_versions_type_id", using: :btree
  end

  create_table "hospital_centres", force: :cascade do |t|
    t.string   "code",                               null: false
    t.string   "name",                               null: false
    t.string   "location"
    t.boolean  "active"
    t.boolean  "is_transplant_site", default: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.index ["code"], name: "index_hospital_centres_on_code", using: :btree
  end

  create_table "hospital_units", force: :cascade do |t|
    t.integer  "hospital_centre_id",                  null: false
    t.string   "name",                                null: false
    t.string   "unit_code",                           null: false
    t.string   "renal_registry_code",                 null: false
    t.string   "unit_type",                           null: false
    t.boolean  "is_hd_site",          default: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["hospital_centre_id"], name: "index_hospital_units_on_hospital_centre_id", using: :btree
  end

  create_table "letter_archives", force: :cascade do |t|
    t.text     "content",       null: false
    t.integer  "created_by_id", null: false
    t.integer  "updated_by_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "letter_id",     null: false
    t.index ["created_by_id"], name: "index_letter_archives_on_created_by_id", using: :btree
    t.index ["letter_id"], name: "index_letter_archives_on_letter_id", using: :btree
    t.index ["updated_by_id"], name: "index_letter_archives_on_updated_by_id", using: :btree
  end

  create_table "letter_contact_descriptions", force: :cascade do |t|
    t.string   "system_code", null: false
    t.string   "name",        null: false
    t.integer  "position",    null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["name"], name: "index_letter_contact_descriptions_on_name", unique: true, using: :btree
    t.index ["position"], name: "index_letter_contact_descriptions_on_position", unique: true, using: :btree
    t.index ["system_code"], name: "index_letter_contact_descriptions_on_system_code", unique: true, using: :btree
  end

  create_table "letter_contacts", force: :cascade do |t|
    t.integer  "patient_id",                        null: false
    t.integer  "person_id",                         null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.boolean  "default_cc",        default: false, null: false
    t.integer  "description_id",                    null: false
    t.string   "other_description"
    t.text     "notes"
    t.index ["description_id"], name: "index_letter_contacts_on_description_id", using: :btree
    t.index ["person_id", "patient_id"], name: "index_letter_contacts_on_person_id_and_patient_id", unique: true, using: :btree
  end

  create_table "letter_descriptions", force: :cascade do |t|
    t.string   "text",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "letter_letterheads", force: :cascade do |t|
    t.string   "name",          null: false
    t.string   "site_code",     null: false
    t.string   "unit_info",     null: false
    t.string   "trust_name",    null: false
    t.string   "trust_caption", null: false
    t.text     "site_info"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "letter_letters", force: :cascade do |t|
    t.string   "event_type"
    t.integer  "event_id"
    t.integer  "patient_id"
    t.string   "type",          null: false
    t.date     "issued_on",     null: false
    t.string   "description"
    t.string   "salutation"
    t.text     "body"
    t.text     "notes"
    t.datetime "signed_at"
    t.integer  "created_by_id", null: false
    t.integer  "updated_by_id", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "letterhead_id", null: false
    t.integer  "author_id",     null: false
    t.boolean  "clinical"
    t.string   "enclosures"
    t.index ["author_id"], name: "index_letter_letters_on_author_id", using: :btree
    t.index ["created_by_id"], name: "index_letter_letters_on_created_by_id", using: :btree
    t.index ["event_type", "event_id"], name: "index_letter_letters_on_event_type_and_event_id", using: :btree
    t.index ["id", "type"], name: "index_letter_letters_on_id_and_type", using: :btree
    t.index ["letterhead_id"], name: "index_letter_letters_on_letterhead_id", using: :btree
    t.index ["patient_id"], name: "index_letter_letters_on_patient_id", using: :btree
    t.index ["updated_by_id"], name: "index_letter_letters_on_updated_by_id", using: :btree
  end

  create_table "letter_recipients", force: :cascade do |t|
    t.string   "role",           null: false
    t.string   "person_role",    null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "letter_id",      null: false
    t.string   "addressee_type"
    t.integer  "addressee_id"
    t.index ["addressee_type", "addressee_id"], name: "index_letter_recipients_on_addressee_type_and_addressee_id", using: :btree
    t.index ["letter_id"], name: "index_letter_recipients_on_letter_id", using: :btree
  end

  create_table "letter_signatures", force: :cascade do |t|
    t.datetime "signed_at",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "letter_id",  null: false
    t.integer  "user_id",    null: false
    t.index ["letter_id"], name: "index_letter_signatures_on_letter_id", using: :btree
    t.index ["user_id"], name: "index_letter_signatures_on_user_id", using: :btree
  end

  create_table "medication_prescription_terminations", force: :cascade do |t|
    t.date     "terminated_on",   null: false
    t.text     "notes"
    t.integer  "prescription_id", null: false
    t.integer  "created_by_id",   null: false
    t.integer  "updated_by_id",   null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["created_by_id"], name: "index_medication_prescription_terminations_on_created_by_id", using: :btree
    t.index ["prescription_id"], name: "index_medication_prescription_terminations_on_prescription_id", using: :btree
    t.index ["updated_by_id"], name: "index_medication_prescription_terminations_on_updated_by_id", using: :btree
  end

  create_table "medication_prescription_versions", force: :cascade do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.jsonb    "object"
    t.jsonb    "object_changes"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_medication_prescription_versions_on_item_type_and_item_id", using: :btree
  end

  create_table "medication_prescriptions", force: :cascade do |t|
    t.integer  "patient_id",                          null: false
    t.integer  "drug_id",                             null: false
    t.string   "treatable_type"
    t.integer  "treatable_id",                        null: false
    t.string   "dose_amount",                         null: false
    t.string   "dose_unit",                           null: false
    t.integer  "medication_route_id",                 null: false
    t.string   "route_description"
    t.string   "frequency",                           null: false
    t.text     "notes"
    t.date     "prescribed_on",                       null: false
    t.integer  "provider",                            null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "created_by_id",                       null: false
    t.integer  "updated_by_id",                       null: false
    t.boolean  "administer_on_hd",    default: false, null: false
    t.date     "last_delivery_date"
    t.index ["created_by_id"], name: "index_medication_prescriptions_on_created_by_id", using: :btree
    t.index ["drug_id", "patient_id"], name: "index_medication_prescriptions_on_drug_id_and_patient_id", using: :btree
    t.index ["drug_id"], name: "index_medication_prescriptions_on_drug_id", using: :btree
    t.index ["medication_route_id"], name: "index_medication_prescriptions_on_medication_route_id", using: :btree
    t.index ["patient_id", "medication_route_id"], name: "idx_mp_patient_id_medication_route_id", using: :btree
    t.index ["patient_id"], name: "index_medication_prescriptions_on_patient_id", using: :btree
    t.index ["treatable_id", "treatable_type"], name: "idx_medication_prescriptions_type", using: :btree
    t.index ["updated_by_id"], name: "index_medication_prescriptions_on_updated_by_id", using: :btree
  end

  create_table "medication_routes", force: :cascade do |t|
    t.string   "code",       null: false
    t.string   "name",       null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "modality_descriptions", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "type"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id", "type"], name: "index_modality_descriptions_on_id_and_type", using: :btree
  end

  create_table "modality_modalities", force: :cascade do |t|
    t.integer  "patient_id",                            null: false
    t.integer  "description_id",                        null: false
    t.integer  "reason_id"
    t.string   "modal_change_type"
    t.text     "notes"
    t.date     "started_on",                            null: false
    t.date     "ended_on"
    t.string   "state",             default: "current", null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "created_by_id",                         null: false
    t.integer  "updated_by_id",                         null: false
    t.index ["created_by_id"], name: "index_modality_modalities_on_created_by_id", using: :btree
    t.index ["description_id"], name: "index_modality_modalities_on_description_id", using: :btree
    t.index ["patient_id", "description_id"], name: "index_modality_modalities_on_patient_id_and_description_id", using: :btree
    t.index ["patient_id"], name: "index_modality_modalities_on_patient_id", using: :btree
    t.index ["reason_id"], name: "index_modality_modalities_on_reason_id", using: :btree
    t.index ["updated_by_id"], name: "index_modality_modalities_on_updated_by_id", using: :btree
  end

  create_table "modality_reasons", force: :cascade do |t|
    t.string   "type"
    t.integer  "rr_code"
    t.string   "description"
    t.datetime "deleted_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["id", "type"], name: "index_modality_reasons_on_id_and_type", using: :btree
  end

  create_table "pathology_labs", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "pathology_observation_descriptions", force: :cascade do |t|
    t.string "code", null: false
    t.string "name"
  end

  create_table "pathology_observation_requests", force: :cascade do |t|
    t.string   "requestor_order_number"
    t.string   "requestor_name",         null: false
    t.datetime "requested_at",           null: false
    t.integer  "patient_id",             null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "description_id",         null: false
    t.index ["description_id"], name: "index_pathology_observation_requests_on_description_id", using: :btree
    t.index ["patient_id"], name: "index_pathology_observation_requests_on_patient_id", using: :btree
  end

  create_table "pathology_observations", force: :cascade do |t|
    t.string   "result",         null: false
    t.text     "comment"
    t.datetime "observed_at",    null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "description_id", null: false
    t.integer  "request_id"
    t.index ["description_id"], name: "index_pathology_observations_on_description_id", using: :btree
    t.index ["request_id"], name: "index_pathology_observations_on_request_id", using: :btree
  end

  create_table "pathology_request_descriptions", force: :cascade do |t|
    t.string  "code",                                            null: false
    t.string  "name"
    t.integer "required_observation_description_id"
    t.integer "expiration_days",                     default: 0, null: false
    t.integer "lab_id",                                          null: false
    t.string  "bottle_type"
    t.index ["lab_id"], name: "index_pathology_request_descriptions_on_lab_id", using: :btree
    t.index ["required_observation_description_id"], name: "prd_required_observation_description_id_idx", using: :btree
  end

  create_table "pathology_request_descriptions_requests_requests", force: :cascade do |t|
    t.integer "request_id",             null: false
    t.integer "request_description_id", null: false
    t.index ["request_description_id"], name: "prdr_requests_description_id_idx", using: :btree
    t.index ["request_id"], name: "prdr_requests_request_id_idx", using: :btree
  end

  create_table "pathology_requests_drug_categories", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "pathology_requests_drugs_drug_categories", force: :cascade do |t|
    t.integer "drug_id",          null: false
    t.integer "drug_category_id", null: false
    t.index ["drug_category_id"], name: "prddc_drug_category_id_idx", using: :btree
    t.index ["drug_id"], name: "index_pathology_requests_drugs_drug_categories_on_drug_id", using: :btree
  end

  create_table "pathology_requests_global_rule_sets", force: :cascade do |t|
    t.integer "request_description_id", null: false
    t.string  "frequency_type",         null: false
    t.integer "clinic_id"
    t.index ["clinic_id"], name: "index_pathology_requests_global_rule_sets_on_clinic_id", using: :btree
    t.index ["request_description_id"], name: "prddc_request_description_id_idx", using: :btree
  end

  create_table "pathology_requests_global_rules", force: :cascade do |t|
    t.integer "rule_set_id"
    t.string  "type"
    t.string  "param_id"
    t.string  "param_comparison_operator"
    t.string  "param_comparison_value"
    t.string  "rule_set_type",             null: false
    t.index ["id", "type"], name: "index_pathology_requests_global_rules_on_id_and_type", using: :btree
    t.index ["rule_set_id", "rule_set_type"], name: "prgr_rule_set_id_and_rule_set_type_idx", using: :btree
  end

  create_table "pathology_requests_patient_rules", force: :cascade do |t|
    t.text    "test_description"
    t.integer "sample_number_bottles"
    t.string  "sample_type"
    t.string  "frequency_type"
    t.integer "patient_id"
    t.date    "start_date"
    t.date    "end_date"
    t.integer "lab_id"
    t.index ["lab_id"], name: "index_pathology_requests_patient_rules_on_lab_id", using: :btree
    t.index ["patient_id"], name: "index_pathology_requests_patient_rules_on_patient_id", using: :btree
  end

  create_table "pathology_requests_patient_rules_requests", force: :cascade do |t|
    t.integer "request_id",      null: false
    t.integer "patient_rule_id", null: false
    t.index ["patient_rule_id"], name: "prprr_patient_rule_id_idx", using: :btree
    t.index ["request_id"], name: "index_pathology_requests_patient_rules_requests_on_request_id", using: :btree
  end

  create_table "pathology_requests_requests", force: :cascade do |t|
    t.integer  "patient_id",    null: false
    t.integer  "clinic_id",     null: false
    t.integer  "consultant_id", null: false
    t.string   "telephone",     null: false
    t.integer  "created_by_id", null: false
    t.integer  "updated_by_id", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "template",      null: false
    t.boolean  "high_risk",     null: false
    t.index ["clinic_id"], name: "index_pathology_requests_requests_on_clinic_id", using: :btree
    t.index ["consultant_id"], name: "index_pathology_requests_requests_on_consultant_id", using: :btree
    t.index ["created_by_id"], name: "index_pathology_requests_requests_on_created_by_id", using: :btree
    t.index ["patient_id"], name: "index_pathology_requests_requests_on_patient_id", using: :btree
    t.index ["updated_by_id"], name: "index_pathology_requests_requests_on_updated_by_id", using: :btree
  end

  create_table "patient_bookmarks", force: :cascade do |t|
    t.integer  "patient_id",                 null: false
    t.integer  "user_id",                    null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.text     "notes"
    t.boolean  "urgent",     default: false, null: false
    t.datetime "deleted_at"
    t.index "patient_id, user_id, (COALESCE(deleted_at, '1970-01-01 00:00:00'::timestamp without time zone))", name: "patient_bookmarks_uniqueness", unique: true, using: :btree
    t.index ["patient_id"], name: "index_patient_bookmarks_on_patient_id", using: :btree
  end

  create_table "patient_ethnicities", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "cfh_name"
    t.string   "rr18_code"
  end

  create_table "patient_languages", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "patient_practices", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "email"
    t.string   "code",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_patient_practices_on_code", using: :btree
  end

  create_table "patient_practices_primary_care_physicians", id: false, force: :cascade do |t|
    t.integer "primary_care_physician_id", null: false
    t.integer "practice_id",               null: false
    t.index ["practice_id"], name: "index_patient_practices_primary_care_physicians_on_practice_id", using: :btree
    t.index ["primary_care_physician_id", "practice_id"], name: "index_doctors_practices", using: :btree
  end

  create_table "patient_primary_care_physicians", force: :cascade do |t|
    t.string   "given_name"
    t.string   "family_name"
    t.string   "email"
    t.string   "code"
    t.string   "practitioner_type", null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "telephone"
    t.index ["code"], name: "index_patient_primary_care_physicians_on_code", unique: true, using: :btree
  end

  create_table "patient_religions", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "patient_versions", force: :cascade do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.jsonb    "object"
    t.jsonb    "object_changes"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "patient_versions_versions_type_id", using: :btree
  end

  create_table "patient_worries", force: :cascade do |t|
    t.integer  "patient_id",    null: false
    t.integer  "updated_by_id", null: false
    t.integer  "created_by_id", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["created_by_id"], name: "index_patient_worries_on_created_by_id", using: :btree
    t.index ["patient_id"], name: "index_patient_worries_on_patient_id", unique: true, using: :btree
    t.index ["updated_by_id"], name: "index_patient_worries_on_updated_by_id", using: :btree
  end

  create_table "patients", force: :cascade do |t|
    t.string   "nhs_number"
    t.string   "local_patient_id"
    t.string   "family_name",                                                        null: false
    t.string   "given_name",                                                         null: false
    t.date     "born_on",                                                            null: false
    t.boolean  "paediatric_patient_indicator"
    t.string   "sex"
    t.integer  "ethnicity_id"
    t.string   "gp_practice_code"
    t.string   "pct_org_code"
    t.string   "hospital_centre_code"
    t.string   "primary_esrf_centre"
    t.date     "died_on"
    t.integer  "first_edta_code_id"
    t.integer  "second_edta_code_id"
    t.text     "death_notes"
    t.boolean  "cc_on_all_letters",            default: true
    t.date     "cc_decision_on"
    t.datetime "created_at",                                                         null: false
    t.datetime "updated_at",                                                         null: false
    t.integer  "practice_id"
    t.integer  "primary_care_physician_id"
    t.integer  "created_by_id",                                                      null: false
    t.integer  "updated_by_id",                                                      null: false
    t.string   "title"
    t.string   "suffix"
    t.string   "marital_status"
    t.string   "telephone1"
    t.string   "telephone2"
    t.string   "email"
    t.jsonb    "document"
    t.integer  "religion_id"
    t.integer  "language_id"
    t.boolean  "diabetic",                     default: false,                       null: false
    t.string   "allergy_status",               default: "unrecorded",                null: false
    t.datetime "allergy_status_updated_at"
    t.string   "local_patient_id_2"
    t.string   "local_patient_id_3"
    t.string   "local_patient_id_4"
    t.string   "local_patient_id_5"
    t.string   "external_patient_id"
    t.boolean  "send_to_renalreg",             default: false,                       null: false
    t.boolean  "send_to_rpv",                  default: false,                       null: false
    t.date     "renalreg_decision_on"
    t.date     "rpv_decision_on"
    t.string   "renalreg_recorded_by"
    t.string   "rpv_recorded_by"
    t.uuid     "uuid",                         default: -> { "uuid_generate_v4()" }, null: false
    t.index ["created_by_id"], name: "index_patients_on_created_by_id", using: :btree
    t.index ["document"], name: "index_patients_on_document", using: :gin
    t.index ["ethnicity_id"], name: "index_patients_on_ethnicity_id", using: :btree
    t.index ["external_patient_id"], name: "index_patients_on_external_patient_id", using: :btree
    t.index ["first_edta_code_id"], name: "index_patients_on_first_edta_code_id", using: :btree
    t.index ["language_id"], name: "index_patients_on_language_id", using: :btree
    t.index ["local_patient_id"], name: "index_patients_on_local_patient_id", using: :btree
    t.index ["local_patient_id_2"], name: "index_patients_on_local_patient_id_2", using: :btree
    t.index ["local_patient_id_3"], name: "index_patients_on_local_patient_id_3", using: :btree
    t.index ["local_patient_id_4"], name: "index_patients_on_local_patient_id_4", using: :btree
    t.index ["local_patient_id_5"], name: "index_patients_on_local_patient_id_5", using: :btree
    t.index ["practice_id"], name: "index_patients_on_practice_id", using: :btree
    t.index ["primary_care_physician_id"], name: "index_patients_on_primary_care_physician_id", using: :btree
    t.index ["religion_id"], name: "index_patients_on_religion_id", using: :btree
    t.index ["second_edta_code_id"], name: "index_patients_on_second_edta_code_id", using: :btree
    t.index ["updated_by_id"], name: "index_patients_on_updated_by_id", using: :btree
    t.index ["uuid"], name: "index_patients_on_uuid", using: :btree
  end

  create_table "pd_assessments", force: :cascade do |t|
    t.integer  "patient_id",    null: false
    t.jsonb    "document"
    t.integer  "created_by_id", null: false
    t.integer  "updated_by_id", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["created_by_id"], name: "index_pd_assessments_on_created_by_id", using: :btree
    t.index ["patient_id"], name: "index_pd_assessments_on_patient_id", using: :btree
    t.index ["updated_by_id"], name: "index_pd_assessments_on_updated_by_id", using: :btree
  end

  create_table "pd_bag_types", force: :cascade do |t|
    t.string   "manufacturer",                                    null: false
    t.string   "description",                                     null: false
    t.decimal  "glucose_content",         precision: 4, scale: 2, null: false
    t.boolean  "amino_acid"
    t.boolean  "icodextrin"
    t.boolean  "low_glucose_degradation"
    t.boolean  "low_sodium"
    t.integer  "sodium_content"
    t.integer  "lactate_content"
    t.integer  "bicarbonate_content"
    t.decimal  "calcium_content",         precision: 3, scale: 2
    t.decimal  "magnesium_content",       precision: 3, scale: 2
    t.datetime "deleted_at"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "glucose_strength",                                null: false
    t.index ["deleted_at"], name: "index_pd_bag_types_on_deleted_at", using: :btree
  end

  create_table "pd_exit_site_infections", force: :cascade do |t|
    t.integer  "patient_id",     null: false
    t.date     "diagnosis_date", null: false
    t.text     "treatment"
    t.text     "outcome"
    t.text     "notes"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["patient_id"], name: "index_pd_exit_site_infections_on_patient_id", using: :btree
  end

  create_table "pd_fluid_descriptions", force: :cascade do |t|
    t.string   "description"
    t.datetime "deleted_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "pd_infection_organisms", force: :cascade do |t|
    t.integer  "organism_code_id", null: false
    t.text     "sensitivity"
    t.string   "infectable_type"
    t.integer  "infectable_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.text     "resistance"
    t.index ["infectable_id", "infectable_type"], name: "idx_infection_organisms_type", using: :btree
    t.index ["organism_code_id", "infectable_id", "infectable_type"], name: "idx_infection_organisms", unique: true, using: :btree
  end

  create_table "pd_organism_codes", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pd_peritonitis_episode_type_descriptions", force: :cascade do |t|
    t.string   "term"
    t.string   "definition"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pd_peritonitis_episode_types", force: :cascade do |t|
    t.integer "peritonitis_episode_id",                  null: false
    t.integer "peritonitis_episode_type_description_id", null: false
    t.index ["peritonitis_episode_id", "peritonitis_episode_type_description_id"], name: "pd_peritonitis_episode_types_unique_id", unique: true, using: :btree
  end

  create_table "pd_peritonitis_episodes", force: :cascade do |t|
    t.integer  "patient_id",           null: false
    t.date     "diagnosis_date",       null: false
    t.date     "treatment_start_date"
    t.date     "treatment_end_date"
    t.integer  "episode_type_id"
    t.boolean  "catheter_removed"
    t.boolean  "line_break"
    t.boolean  "exit_site_infection"
    t.boolean  "diarrhoea"
    t.boolean  "abdominal_pain"
    t.integer  "fluid_description_id"
    t.integer  "white_cell_total"
    t.integer  "white_cell_neutro"
    t.integer  "white_cell_lympho"
    t.integer  "white_cell_degen"
    t.integer  "white_cell_other"
    t.text     "notes"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["episode_type_id"], name: "index_pd_peritonitis_episodes_on_episode_type_id", using: :btree
    t.index ["fluid_description_id"], name: "index_pd_peritonitis_episodes_on_fluid_description_id", using: :btree
    t.index ["patient_id"], name: "index_pd_peritonitis_episodes_on_patient_id", using: :btree
  end

  create_table "pd_pet_adequacy_results", force: :cascade do |t|
    t.integer  "patient_id",                                           null: false
    t.date     "pet_date"
    t.string   "pet_type"
    t.decimal  "pet_duration",                 precision: 8, scale: 1
    t.integer  "pet_net_uf"
    t.decimal  "dialysate_creat_plasma_ratio", precision: 8, scale: 2
    t.decimal  "dialysate_glucose_start",      precision: 8, scale: 1
    t.decimal  "dialysate_glucose_end",        precision: 8, scale: 1
    t.date     "adequacy_date"
    t.decimal  "ktv_total",                    precision: 8, scale: 2
    t.decimal  "ktv_dialysate",                precision: 8, scale: 2
    t.decimal  "ktv_rrf",                      precision: 8, scale: 2
    t.integer  "crcl_total"
    t.integer  "crcl_dialysate"
    t.integer  "crcl_rrf"
    t.integer  "daily_uf"
    t.integer  "daily_urine"
    t.date     "date_rff"
    t.integer  "creat_value"
    t.decimal  "dialysate_effluent_volume",    precision: 8, scale: 2
    t.date     "date_creat_clearance"
    t.date     "date_creat_value"
    t.decimal  "urine_urea_conc",              precision: 8, scale: 1
    t.integer  "urine_creat_conc"
    t.integer  "created_by_id",                                        null: false
    t.integer  "updated_by_id",                                        null: false
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.index ["created_by_id"], name: "index_pd_pet_adequacy_results_on_created_by_id", using: :btree
    t.index ["updated_by_id"], name: "index_pd_pet_adequacy_results_on_updated_by_id", using: :btree
  end

  create_table "pd_regime_bags", force: :cascade do |t|
    t.integer  "regime_id",                          null: false
    t.integer  "bag_type_id",                        null: false
    t.integer  "volume",                             null: false
    t.integer  "per_week"
    t.boolean  "monday"
    t.boolean  "tuesday"
    t.boolean  "wednesday"
    t.boolean  "thursday"
    t.boolean  "friday"
    t.boolean  "saturday"
    t.boolean  "sunday"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "role"
    t.boolean  "capd_overnight_bag", default: false, null: false
    t.index ["bag_type_id"], name: "index_pd_regime_bags_on_bag_type_id", using: :btree
    t.index ["regime_id"], name: "index_pd_regime_bags_on_regime_id", using: :btree
  end

  create_table "pd_regime_terminations", force: :cascade do |t|
    t.date     "terminated_on", null: false
    t.integer  "regime_id",     null: false
    t.integer  "created_by_id", null: false
    t.integer  "updated_by_id", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["created_by_id"], name: "index_pd_regime_terminations_on_created_by_id", using: :btree
    t.index ["regime_id"], name: "index_pd_regime_terminations_on_regime_id", using: :btree
    t.index ["updated_by_id"], name: "index_pd_regime_terminations_on_updated_by_id", using: :btree
  end

  create_table "pd_regimes", force: :cascade do |t|
    t.integer  "patient_id",                                         null: false
    t.date     "start_date",                                         null: false
    t.date     "end_date"
    t.string   "treatment",                                          null: false
    t.string   "type"
    t.integer  "glucose_volume_low_strength"
    t.integer  "glucose_volume_medium_strength"
    t.integer  "glucose_volume_high_strength"
    t.integer  "amino_acid_volume"
    t.integer  "icodextrin_volume"
    t.boolean  "add_hd"
    t.integer  "last_fill_volume"
    t.boolean  "tidal_indicator"
    t.integer  "tidal_percentage"
    t.integer  "no_cycles_per_apd"
    t.integer  "overnight_volume"
    t.string   "apd_machine_pac"
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.integer  "therapy_time"
    t.integer  "fill_volume"
    t.string   "delivery_interval"
    t.integer  "system_id"
    t.integer  "additional_manual_exchange_volume"
    t.boolean  "tidal_full_drain_every_three_cycles", default: true
    t.integer  "daily_volume"
    t.string   "assistance_type"
    t.index ["id", "type"], name: "index_pd_regimes_on_id_and_type", using: :btree
    t.index ["patient_id"], name: "index_pd_regimes_on_patient_id", using: :btree
    t.index ["system_id"], name: "index_pd_regimes_on_system_id", using: :btree
  end

  create_table "pd_systems", force: :cascade do |t|
    t.string   "pd_type",    null: false
    t.string   "name",       null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pd_type"], name: "index_pd_systems_on_pd_type", using: :btree
  end

  create_table "pd_training_sessions", force: :cascade do |t|
    t.integer  "patient_id",       null: false
    t.integer  "training_site_id", null: false
    t.jsonb    "document"
    t.integer  "created_by_id",    null: false
    t.integer  "updated_by_id",    null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "training_type_id", null: false
    t.index ["created_by_id"], name: "index_pd_training_sessions_on_created_by_id", using: :btree
    t.index ["patient_id"], name: "index_pd_training_sessions_on_patient_id", using: :btree
    t.index ["training_site_id"], name: "index_pd_training_sessions_on_training_site_id", using: :btree
    t.index ["training_type_id"], name: "index_pd_training_sessions_on_training_type_id", using: :btree
    t.index ["updated_by_id"], name: "index_pd_training_sessions_on_updated_by_id", using: :btree
  end

  create_table "pd_training_sites", force: :cascade do |t|
    t.string   "code",       null: false
    t.string   "name",       null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pd_training_types", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "problem_notes", force: :cascade do |t|
    t.integer  "problem_id"
    t.text     "description",   null: false
    t.integer  "created_by_id", null: false
    t.integer  "updated_by_id", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["created_by_id"], name: "index_problem_notes_on_created_by_id", using: :btree
    t.index ["problem_id"], name: "index_problem_notes_on_problem_id", using: :btree
    t.index ["updated_by_id"], name: "index_problem_notes_on_updated_by_id", using: :btree
  end

  create_table "problem_problems", force: :cascade do |t|
    t.integer  "position",      default: 0, null: false
    t.integer  "patient_id",                null: false
    t.string   "description",               null: false
    t.date     "date"
    t.datetime "deleted_at"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "created_by_id",             null: false
    t.integer  "updated_by_id"
    t.index ["created_by_id"], name: "index_problem_problems_on_created_by_id", using: :btree
    t.index ["deleted_at"], name: "index_problem_problems_on_deleted_at", using: :btree
    t.index ["patient_id"], name: "index_problem_problems_on_patient_id", using: :btree
    t.index ["position"], name: "index_problem_problems_on_position", using: :btree
    t.index ["updated_by_id"], name: "index_problem_problems_on_updated_by_id", using: :btree
  end

  create_table "problem_versions", force: :cascade do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.jsonb    "object"
    t.jsonb    "object_changes"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_problem_versions_on_item_type_and_item_id", using: :btree
  end

  create_table "renal_prd_descriptions", force: :cascade do |t|
    t.string   "code"
    t.string   "term"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "renal_profiles", force: :cascade do |t|
    t.integer  "patient_id",               null: false
    t.date     "esrf_on"
    t.date     "first_seen_on"
    t.float    "weight_at_esrf"
    t.string   "modality_at_esrf"
    t.integer  "prd_description_id"
    t.date     "comorbidities_updated_on"
    t.jsonb    "document"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["document"], name: "index_renal_profiles_on_document", using: :gin
    t.index ["patient_id"], name: "index_renal_profiles_on_patient_id", using: :btree
    t.index ["prd_description_id"], name: "index_renal_profiles_on_prd_description_id", using: :btree
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "hidden",     default: false, null: false
  end

  create_table "roles_users", id: false, force: :cascade do |t|
    t.integer "role_id"
    t.integer "user_id"
    t.index ["user_id", "role_id"], name: "index_roles_users_on_user_id_and_role_id", unique: true, using: :btree
  end

  create_table "snippets_snippets", force: :cascade do |t|
    t.string   "title",                    null: false
    t.text     "body",                     null: false
    t.datetime "last_used_on"
    t.integer  "times_used",   default: 0, null: false
    t.integer  "author_id",                null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["author_id"], name: "index_snippets_snippets_on_author_id", using: :btree
    t.index ["title"], name: "index_snippets_snippets_on_title", using: :btree
  end

  create_table "transplant_donations", force: :cascade do |t|
    t.integer  "patient_id"
    t.integer  "recipient_id"
    t.string   "state",                             null: false
    t.string   "relationship_with_recipient",       null: false
    t.string   "relationship_with_recipient_other"
    t.string   "blood_group_compatibility"
    t.string   "mismatch_grade"
    t.string   "paired_pooled_donation"
    t.date     "volunteered_on"
    t.date     "first_seen_on"
    t.date     "workup_completed_on"
    t.date     "donated_on"
    t.text     "notes"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.index ["patient_id"], name: "index_transplant_donations_on_patient_id", using: :btree
    t.index ["recipient_id"], name: "index_transplant_donations_on_recipient_id", using: :btree
  end

  create_table "transplant_donor_followups", force: :cascade do |t|
    t.integer  "operation_id",             null: false
    t.text     "notes"
    t.boolean  "followed_up"
    t.string   "ukt_center_code"
    t.date     "last_seen_on"
    t.boolean  "lost_to_followup"
    t.boolean  "transferred_for_followup"
    t.date     "dead_on"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["operation_id"], name: "index_transplant_donor_followups_on_operation_id", using: :btree
  end

  create_table "transplant_donor_operations", force: :cascade do |t|
    t.integer  "patient_id"
    t.date     "performed_on",                               null: false
    t.string   "anaesthetist"
    t.string   "donor_splenectomy_peri_or_post_operatively"
    t.string   "kidney_side"
    t.string   "nephrectomy_type"
    t.string   "nephrectomy_type_other"
    t.string   "operating_surgeon"
    t.text     "notes"
    t.jsonb    "document"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.index ["document"], name: "index_transplant_donor_operations_on_document", using: :gin
    t.index ["patient_id"], name: "index_transplant_donor_operations_on_patient_id", using: :btree
  end

  create_table "transplant_donor_stage_positions", force: :cascade do |t|
    t.string   "name",                   null: false
    t.integer  "position",   default: 1, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["name"], name: "index_transplant_donor_stage_positions_on_name", unique: true, using: :btree
    t.index ["position"], name: "index_transplant_donor_stage_positions_on_position", using: :btree
  end

  create_table "transplant_donor_stage_statuses", force: :cascade do |t|
    t.string   "name",                   null: false
    t.integer  "position",   default: 1, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["name"], name: "index_transplant_donor_stage_statuses_on_name", unique: true, using: :btree
    t.index ["position"], name: "index_transplant_donor_stage_statuses_on_position", using: :btree
  end

  create_table "transplant_donor_stages", force: :cascade do |t|
    t.integer  "patient_id",        null: false
    t.integer  "stage_position_id", null: false
    t.integer  "stage_status_id",   null: false
    t.integer  "created_by_id",     null: false
    t.integer  "updated_by_id",     null: false
    t.datetime "started_on",        null: false
    t.datetime "terminated_on"
    t.text     "notes"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["created_by_id"], name: "index_transplant_donor_stages_on_created_by_id", using: :btree
    t.index ["patient_id"], name: "index_transplant_donor_stages_on_patient_id", using: :btree
    t.index ["stage_position_id"], name: "tx_donor_stage_position_idx", using: :btree
    t.index ["stage_status_id"], name: "tx_donor_stage_status_idx", using: :btree
    t.index ["updated_by_id"], name: "index_transplant_donor_stages_on_updated_by_id", using: :btree
  end

  create_table "transplant_donor_workups", force: :cascade do |t|
    t.integer  "patient_id"
    t.jsonb    "document"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document"], name: "index_transplant_donor_workups_on_document", using: :gin
    t.index ["patient_id"], name: "index_transplant_donor_workups_on_patient_id", using: :btree
  end

  create_table "transplant_failure_cause_description_groups", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transplant_failure_cause_descriptions", force: :cascade do |t|
    t.integer  "group_id"
    t.string   "code",       null: false
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_transplant_failure_cause_descriptions_on_code", unique: true, using: :btree
    t.index ["group_id"], name: "index_transplant_failure_cause_descriptions_on_group_id", using: :btree
  end

  create_table "transplant_recipient_followups", force: :cascade do |t|
    t.integer  "operation_id",                            null: false
    t.text     "notes"
    t.date     "stent_removed_on"
    t.boolean  "transplant_failed"
    t.date     "transplant_failed_on"
    t.integer  "transplant_failure_cause_description_id"
    t.string   "transplant_failure_cause_other"
    t.text     "transplant_failure_notes"
    t.jsonb    "document"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.index ["document"], name: "index_transplant_recipient_followups_on_document", using: :gin
    t.index ["operation_id"], name: "index_transplant_recipient_followups_on_operation_id", using: :btree
    t.index ["transplant_failure_cause_description_id"], name: "tx_recip_fol_failure_cause_description_id_idx", using: :btree
  end

  create_table "transplant_recipient_operations", force: :cascade do |t|
    t.integer  "patient_id"
    t.date     "performed_on",                     null: false
    t.time     "theatre_case_start_time",          null: false
    t.datetime "donor_kidney_removed_from_ice_at", null: false
    t.string   "operation_type",                   null: false
    t.integer  "hospital_centre_id",               null: false
    t.datetime "kidney_perfused_with_blood_at",    null: false
    t.integer  "cold_ischaemic_time",              null: false
    t.integer  "warm_ischaemic_time",              null: false
    t.text     "notes"
    t.jsonb    "document"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.index ["document"], name: "index_transplant_recipient_operations_on_document", using: :gin
    t.index ["hospital_centre_id"], name: "index_transplant_recipient_operations_on_hospital_centre_id", using: :btree
    t.index ["patient_id"], name: "index_transplant_recipient_operations_on_patient_id", using: :btree
  end

  create_table "transplant_recipient_workups", force: :cascade do |t|
    t.integer  "patient_id"
    t.jsonb    "document"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "created_by_id", null: false
    t.integer  "updated_by_id", null: false
    t.index ["created_by_id"], name: "index_transplant_recipient_workups_on_created_by_id", using: :btree
    t.index ["document"], name: "index_transplant_recipient_workups_on_document", using: :gin
    t.index ["patient_id"], name: "index_transplant_recipient_workups_on_patient_id", using: :btree
    t.index ["updated_by_id"], name: "index_transplant_recipient_workups_on_updated_by_id", using: :btree
  end

  create_table "transplant_registration_status_descriptions", force: :cascade do |t|
    t.string   "code",                   null: false
    t.string   "name"
    t.integer  "position",   default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["code"], name: "index_transplant_registration_status_descriptions_on_code", using: :btree
  end

  create_table "transplant_registration_statuses", force: :cascade do |t|
    t.integer  "registration_id"
    t.integer  "description_id"
    t.date     "started_on",      null: false
    t.date     "terminated_on"
    t.integer  "created_by_id",   null: false
    t.integer  "updated_by_id",   null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["created_by_id"], name: "index_transplant_registration_statuses_on_created_by_id", using: :btree
    t.index ["description_id"], name: "index_transplant_registration_statuses_on_description_id", using: :btree
    t.index ["registration_id"], name: "index_transplant_registration_statuses_on_registration_id", using: :btree
    t.index ["updated_by_id"], name: "index_transplant_registration_statuses_on_updated_by_id", using: :btree
  end

  create_table "transplant_registrations", force: :cascade do |t|
    t.integer  "patient_id"
    t.date     "referred_on"
    t.date     "assessed_on"
    t.date     "entered_on"
    t.text     "contact"
    t.text     "notes"
    t.jsonb    "document"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["document"], name: "index_transplant_registrations_on_document", using: :gin
    t.index ["patient_id"], name: "index_transplant_registrations_on_patient_id", using: :btree
  end

  create_table "transplant_versions", force: :cascade do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.jsonb    "object"
    t.jsonb    "object_changes"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "tx_versions_type_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "username",                               null: false
    t.string   "given_name",                             null: false
    t.string   "family_name",                            null: false
    t.string   "signature"
    t.datetime "last_activity_at"
    t.datetime "expired_at"
    t.string   "professional_position"
    t.boolean  "approved",               default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "telephone"
    t.index ["approved"], name: "index_users_on_approved", using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["expired_at"], name: "index_users_on_expired_at", using: :btree
    t.index ["last_activity_at"], name: "index_users_on_last_activity_at", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.jsonb    "object"
    t.jsonb    "object_changes"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  end

  add_foreign_key "access_assessments", "access_sites", column: "site_id"
  add_foreign_key "access_assessments", "access_types", column: "type_id"
  add_foreign_key "access_assessments", "patients"
  add_foreign_key "access_assessments", "users", column: "created_by_id", name: "access_assessments_created_by_id_fk"
  add_foreign_key "access_assessments", "users", column: "updated_by_id", name: "access_assessments_updated_by_id_fk"
  add_foreign_key "access_procedures", "access_sites", column: "site_id"
  add_foreign_key "access_procedures", "access_types", column: "type_id"
  add_foreign_key "access_procedures", "patients"
  add_foreign_key "access_procedures", "users", column: "created_by_id", name: "access_procedures_created_by_id_fk"
  add_foreign_key "access_procedures", "users", column: "updated_by_id", name: "access_procedures_updated_by_id_fk"
  add_foreign_key "access_profiles", "access_plans", column: "plan_id"
  add_foreign_key "access_profiles", "access_sites", column: "site_id"
  add_foreign_key "access_profiles", "access_types", column: "type_id"
  add_foreign_key "access_profiles", "patients"
  add_foreign_key "access_profiles", "users", column: "created_by_id", name: "access_profiles_created_by_id_fk"
  add_foreign_key "access_profiles", "users", column: "decided_by_id"
  add_foreign_key "access_profiles", "users", column: "updated_by_id", name: "access_profiles_updated_by_id_fk"
  add_foreign_key "clinic_appointments", "clinic_clinics", column: "clinic_id"
  add_foreign_key "clinic_appointments", "clinic_visits", column: "becomes_visit_id"
  add_foreign_key "clinic_appointments", "patients"
  add_foreign_key "clinic_appointments", "users"
  add_foreign_key "clinic_clinics", "users"
  add_foreign_key "clinic_visits", "clinic_clinics", column: "clinic_id"
  add_foreign_key "clinic_visits", "patients", name: "clinic_visits_patient_id_fk"
  add_foreign_key "clinic_visits", "users", column: "created_by_id", name: "clinic_visits_created_by_id_fk"
  add_foreign_key "clinic_visits", "users", column: "updated_by_id", name: "clinic_visits_updated_by_id_fk"
  add_foreign_key "clinical_allergies", "patients"
  add_foreign_key "clinical_allergies", "users", column: "created_by_id"
  add_foreign_key "clinical_allergies", "users", column: "updated_by_id"
  add_foreign_key "clinical_dry_weights", "patients"
  add_foreign_key "clinical_dry_weights", "users", column: "assessor_id"
  add_foreign_key "clinical_dry_weights", "users", column: "created_by_id", name: "hd_dry_weights_created_by_id_fk"
  add_foreign_key "clinical_dry_weights", "users", column: "updated_by_id", name: "hd_dry_weights_updated_by_id_fk"
  add_foreign_key "directory_people", "users", column: "created_by_id", name: "directory_people_created_by_id_fk"
  add_foreign_key "directory_people", "users", column: "updated_by_id", name: "directory_people_updated_by_id_fk"
  add_foreign_key "drug_types_drugs", "drug_types"
  add_foreign_key "drug_types_drugs", "drugs"
  add_foreign_key "events", "event_types"
  add_foreign_key "events", "patients"
  add_foreign_key "events", "users", column: "created_by_id", name: "events_created_by_id_fk"
  add_foreign_key "events", "users", column: "updated_by_id", name: "events_updated_by_id_fk"
  add_foreign_key "hd_patient_statistics", "hospital_units"
  add_foreign_key "hd_patient_statistics", "patients"
  add_foreign_key "hd_preference_sets", "hospital_units"
  add_foreign_key "hd_preference_sets", "patients"
  add_foreign_key "hd_preference_sets", "users", column: "created_by_id", name: "hd_preference_sets_created_by_id_fk"
  add_foreign_key "hd_preference_sets", "users", column: "updated_by_id", name: "hd_preference_sets_updated_by_id_fk"
  add_foreign_key "hd_prescription_administrations", "hd_sessions"
  add_foreign_key "hd_prescription_administrations", "medication_prescriptions", column: "prescription_id"
  add_foreign_key "hd_prescription_administrations", "users", column: "created_by_id"
  add_foreign_key "hd_prescription_administrations", "users", column: "updated_by_id"
  add_foreign_key "hd_profiles", "hospital_units"
  add_foreign_key "hd_profiles", "patients"
  add_foreign_key "hd_profiles", "users", column: "created_by_id", name: "hd_profiles_created_by_id_fk"
  add_foreign_key "hd_profiles", "users", column: "named_nurse_id"
  add_foreign_key "hd_profiles", "users", column: "prescriber_id"
  add_foreign_key "hd_profiles", "users", column: "transport_decider_id"
  add_foreign_key "hd_profiles", "users", column: "updated_by_id", name: "hd_profiles_updated_by_id_fk"
  add_foreign_key "hd_sessions", "clinical_dry_weights", column: "dry_weight_id"
  add_foreign_key "hd_sessions", "hd_profiles", column: "profile_id"
  add_foreign_key "hd_sessions", "hospital_units"
  add_foreign_key "hd_sessions", "modality_descriptions"
  add_foreign_key "hd_sessions", "patients"
  add_foreign_key "hd_sessions", "users", column: "created_by_id", name: "hd_sessions_created_by_id_fk"
  add_foreign_key "hd_sessions", "users", column: "signed_off_by_id"
  add_foreign_key "hd_sessions", "users", column: "signed_on_by_id"
  add_foreign_key "hd_sessions", "users", column: "updated_by_id", name: "hd_sessions_updated_by_id_fk"
  add_foreign_key "hospital_units", "hospital_centres"
  add_foreign_key "letter_archives", "letter_letters", column: "letter_id"
  add_foreign_key "letter_archives", "users", column: "created_by_id", name: "letter_archives_created_by_id_fk"
  add_foreign_key "letter_archives", "users", column: "updated_by_id", name: "letter_archives_updated_by_id_fk"
  add_foreign_key "letter_contacts", "directory_people", column: "person_id"
  add_foreign_key "letter_contacts", "letter_contact_descriptions", column: "description_id"
  add_foreign_key "letter_contacts", "patients"
  add_foreign_key "letter_letters", "letter_letterheads", column: "letterhead_id"
  add_foreign_key "letter_letters", "patients", name: "letter_letters_patient_id_fk"
  add_foreign_key "letter_letters", "users", column: "author_id"
  add_foreign_key "letter_letters", "users", column: "created_by_id", name: "letter_letters_created_by_id_fk"
  add_foreign_key "letter_letters", "users", column: "updated_by_id", name: "letter_letters_updated_by_id_fk"
  add_foreign_key "letter_recipients", "letter_letters", column: "letter_id"
  add_foreign_key "letter_signatures", "letter_letters", column: "letter_id"
  add_foreign_key "letter_signatures", "users"
  add_foreign_key "medication_prescription_terminations", "medication_prescriptions", column: "prescription_id"
  add_foreign_key "medication_prescription_terminations", "users", column: "created_by_id"
  add_foreign_key "medication_prescription_terminations", "users", column: "updated_by_id"
  add_foreign_key "medication_prescriptions", "drugs"
  add_foreign_key "medication_prescriptions", "medication_routes"
  add_foreign_key "medication_prescriptions", "patients"
  add_foreign_key "medication_prescriptions", "users", column: "created_by_id"
  add_foreign_key "medication_prescriptions", "users", column: "updated_by_id"
  add_foreign_key "modality_modalities", "modality_descriptions", column: "description_id"
  add_foreign_key "modality_modalities", "modality_reasons", column: "reason_id"
  add_foreign_key "modality_modalities", "patients"
  add_foreign_key "modality_modalities", "users", column: "created_by_id", name: "modality_modalities_created_by_id_fk"
  add_foreign_key "modality_modalities", "users", column: "updated_by_id", name: "modality_modalities_updated_by_id_fk"
  add_foreign_key "pathology_observation_requests", "pathology_request_descriptions", column: "description_id"
  add_foreign_key "pathology_observation_requests", "patients"
  add_foreign_key "pathology_observations", "pathology_observation_descriptions", column: "description_id"
  add_foreign_key "pathology_observations", "pathology_observation_requests", column: "request_id"
  add_foreign_key "pathology_request_descriptions", "pathology_labs", column: "lab_id"
  add_foreign_key "pathology_request_descriptions", "pathology_observation_descriptions", column: "required_observation_description_id"
  add_foreign_key "pathology_request_descriptions_requests_requests", "pathology_request_descriptions", column: "request_description_id"
  add_foreign_key "pathology_request_descriptions_requests_requests", "pathology_requests_requests", column: "request_id"
  add_foreign_key "pathology_requests_drugs_drug_categories", "drugs"
  add_foreign_key "pathology_requests_drugs_drug_categories", "pathology_requests_drug_categories", column: "drug_category_id"
  add_foreign_key "pathology_requests_global_rule_sets", "clinic_clinics", column: "clinic_id"
  add_foreign_key "pathology_requests_global_rule_sets", "pathology_request_descriptions", column: "request_description_id"
  add_foreign_key "pathology_requests_global_rules", "pathology_requests_global_rule_sets", column: "rule_set_id"
  add_foreign_key "pathology_requests_patient_rules", "pathology_labs", column: "lab_id"
  add_foreign_key "pathology_requests_patient_rules", "patients"
  add_foreign_key "pathology_requests_patient_rules_requests", "pathology_requests_patient_rules", column: "patient_rule_id"
  add_foreign_key "pathology_requests_patient_rules_requests", "pathology_requests_requests", column: "request_id"
  add_foreign_key "pathology_requests_requests", "clinic_clinics", column: "clinic_id"
  add_foreign_key "pathology_requests_requests", "patients"
  add_foreign_key "pathology_requests_requests", "users", column: "consultant_id"
  add_foreign_key "pathology_requests_requests", "users", column: "created_by_id", name: "pathology_requests_requests_created_by_id_fk"
  add_foreign_key "pathology_requests_requests", "users", column: "updated_by_id", name: "pathology_requests_requests_updated_by_id_fk"
  add_foreign_key "patient_bookmarks", "patients"
  add_foreign_key "patient_bookmarks", "users"
  add_foreign_key "patient_practices_primary_care_physicians", "patient_practices", column: "practice_id"
  add_foreign_key "patient_practices_primary_care_physicians", "patient_primary_care_physicians", column: "primary_care_physician_id"
  add_foreign_key "patient_worries", "patients"
  add_foreign_key "patient_worries", "users", column: "created_by_id"
  add_foreign_key "patient_worries", "users", column: "updated_by_id"
  add_foreign_key "patients", "death_edta_codes", column: "first_edta_code_id"
  add_foreign_key "patients", "death_edta_codes", column: "second_edta_code_id"
  add_foreign_key "patients", "patient_ethnicities", column: "ethnicity_id"
  add_foreign_key "patients", "patient_languages", column: "language_id"
  add_foreign_key "patients", "patient_practices", column: "practice_id", name: "patients_practice_id_fk"
  add_foreign_key "patients", "patient_primary_care_physicians", column: "primary_care_physician_id"
  add_foreign_key "patients", "patient_religions", column: "religion_id"
  add_foreign_key "patients", "users", column: "created_by_id", name: "patients_created_by_id_fk"
  add_foreign_key "patients", "users", column: "updated_by_id", name: "patients_updated_by_id_fk"
  add_foreign_key "pd_assessments", "patients"
  add_foreign_key "pd_assessments", "users", column: "created_by_id"
  add_foreign_key "pd_assessments", "users", column: "updated_by_id"
  add_foreign_key "pd_exit_site_infections", "patients"
  add_foreign_key "pd_infection_organisms", "pd_organism_codes", column: "organism_code_id"
  add_foreign_key "pd_peritonitis_episode_types", "pd_peritonitis_episode_type_descriptions", column: "peritonitis_episode_type_description_id"
  add_foreign_key "pd_peritonitis_episode_types", "pd_peritonitis_episodes", column: "peritonitis_episode_id"
  add_foreign_key "pd_peritonitis_episodes", "patients"
  add_foreign_key "pd_peritonitis_episodes", "pd_fluid_descriptions", column: "fluid_description_id"
  add_foreign_key "pd_peritonitis_episodes", "pd_peritonitis_episode_type_descriptions", column: "episode_type_id"
  add_foreign_key "pd_pet_adequacy_results", "patients"
  add_foreign_key "pd_pet_adequacy_results", "users", column: "created_by_id"
  add_foreign_key "pd_pet_adequacy_results", "users", column: "updated_by_id"
  add_foreign_key "pd_regime_bags", "pd_bag_types", column: "bag_type_id"
  add_foreign_key "pd_regime_bags", "pd_regimes", column: "regime_id"
  add_foreign_key "pd_regime_terminations", "pd_regimes", column: "regime_id"
  add_foreign_key "pd_regime_terminations", "users", column: "created_by_id"
  add_foreign_key "pd_regime_terminations", "users", column: "updated_by_id"
  add_foreign_key "pd_regimes", "patients"
  add_foreign_key "pd_regimes", "pd_systems", column: "system_id", name: "pd_regimes_system_id_fk"
  add_foreign_key "pd_training_sessions", "patients"
  add_foreign_key "pd_training_sessions", "pd_training_sites", column: "training_site_id", name: "pd_training_sessions_site_id_fk"
  add_foreign_key "pd_training_sessions", "pd_training_types", column: "training_type_id", name: "pd_training_sessions_type_id_fk"
  add_foreign_key "pd_training_sessions", "users", column: "created_by_id"
  add_foreign_key "pd_training_sessions", "users", column: "updated_by_id"
  add_foreign_key "problem_notes", "problem_problems", column: "problem_id"
  add_foreign_key "problem_notes", "users", column: "created_by_id", name: "problem_notes_created_by_id_fk"
  add_foreign_key "problem_notes", "users", column: "updated_by_id", name: "problem_notes_updated_by_id_fk"
  add_foreign_key "problem_problems", "patients"
  add_foreign_key "problem_problems", "users", column: "created_by_id"
  add_foreign_key "problem_problems", "users", column: "updated_by_id"
  add_foreign_key "renal_profiles", "patients"
  add_foreign_key "renal_profiles", "renal_prd_descriptions", column: "prd_description_id"
  add_foreign_key "roles_users", "roles"
  add_foreign_key "roles_users", "users"
  add_foreign_key "snippets_snippets", "users", column: "author_id"
  add_foreign_key "transplant_donations", "patients"
  add_foreign_key "transplant_donations", "patients", column: "recipient_id", name: "transplant_donations_recipient_id_fk"
  add_foreign_key "transplant_donor_followups", "transplant_donor_operations", column: "operation_id"
  add_foreign_key "transplant_donor_operations", "patients"
  add_foreign_key "transplant_donor_stages", "patients"
  add_foreign_key "transplant_donor_stages", "transplant_donor_stage_positions", column: "stage_position_id"
  add_foreign_key "transplant_donor_stages", "transplant_donor_stage_statuses", column: "stage_status_id"
  add_foreign_key "transplant_donor_stages", "users", column: "created_by_id"
  add_foreign_key "transplant_donor_stages", "users", column: "updated_by_id"
  add_foreign_key "transplant_donor_workups", "patients"
  add_foreign_key "transplant_failure_cause_descriptions", "transplant_failure_cause_description_groups", column: "group_id"
  add_foreign_key "transplant_recipient_followups", "transplant_failure_cause_descriptions"
  add_foreign_key "transplant_recipient_followups", "transplant_recipient_operations", column: "operation_id"
  add_foreign_key "transplant_recipient_operations", "hospital_centres"
  add_foreign_key "transplant_recipient_operations", "patients"
  add_foreign_key "transplant_recipient_workups", "patients"
  add_foreign_key "transplant_registration_statuses", "transplant_registration_status_descriptions", column: "description_id"
  add_foreign_key "transplant_registration_statuses", "transplant_registrations", column: "registration_id"
  add_foreign_key "transplant_registration_statuses", "users", column: "created_by_id", name: "transplant_registration_statuses_created_by_id_fk"
  add_foreign_key "transplant_registration_statuses", "users", column: "updated_by_id", name: "transplant_registration_statuses_updated_by_id_fk"
  add_foreign_key "transplant_registrations", "patients"

  create_view "pathology_current_observations",  sql_definition: <<-SQL
      SELECT DISTINCT ON (pathology_observation_requests.patient_id, pathology_observation_descriptions.id) pathology_observations.id,
      pathology_observations.result,
      pathology_observations.comment,
      pathology_observations.observed_at,
      pathology_observations.description_id,
      pathology_observations.request_id,
      pathology_observation_descriptions.code AS description_code,
      pathology_observation_descriptions.name AS description_name,
      pathology_observation_requests.patient_id
     FROM ((pathology_observations
       LEFT JOIN pathology_observation_requests ON ((pathology_observations.request_id = pathology_observation_requests.id)))
       LEFT JOIN pathology_observation_descriptions ON ((pathology_observations.description_id = pathology_observation_descriptions.id)))
    ORDER BY pathology_observation_requests.patient_id, pathology_observation_descriptions.id, pathology_observations.observed_at DESC;
  SQL

  create_view "pathology_current_key_observation_sets",  sql_definition: <<-SQL
      SELECT p.id AS patient_id,
      ( SELECT pathology_current_observations.result
             FROM pathology_current_observations
            WHERE (((pathology_current_observations.description_code)::text = 'HGB'::text) AND (pathology_current_observations.patient_id = p.id))) AS hgb_result,
      ( SELECT pathology_current_observations.observed_at
             FROM pathology_current_observations
            WHERE (((pathology_current_observations.description_code)::text = 'HGB'::text) AND (pathology_current_observations.patient_id = p.id))) AS hgb_observed_at,
      ( SELECT pathology_current_observations.result
             FROM pathology_current_observations
            WHERE (((pathology_current_observations.description_code)::text = 'CRE'::text) AND (pathology_current_observations.patient_id = p.id))) AS cre_result,
      ( SELECT pathology_current_observations.observed_at
             FROM pathology_current_observations
            WHERE (((pathology_current_observations.description_code)::text = 'CRE'::text) AND (pathology_current_observations.patient_id = p.id))) AS cre_observed_at,
      ( SELECT pathology_current_observations.result
             FROM pathology_current_observations
            WHERE (((pathology_current_observations.description_code)::text = 'URE'::text) AND (pathology_current_observations.patient_id = p.id))) AS ure_result,
      ( SELECT pathology_current_observations.observed_at
             FROM pathology_current_observations
            WHERE (((pathology_current_observations.description_code)::text = 'URE'::text) AND (pathology_current_observations.patient_id = p.id))) AS ure_observed_at,
      ( SELECT pathology_current_observations.result
             FROM pathology_current_observations
            WHERE (((pathology_current_observations.description_code)::text = 'MDRD'::text) AND (pathology_current_observations.patient_id = p.id))) AS mdrd_result,
      ( SELECT pathology_current_observations.observed_at
             FROM pathology_current_observations
            WHERE (((pathology_current_observations.description_code)::text = 'MDRD'::text) AND (pathology_current_observations.patient_id = p.id))) AS mdrd_observed_at,
      ( SELECT pathology_current_observations.result
             FROM pathology_current_observations
            WHERE (((pathology_current_observations.description_code)::text = 'HBA'::text) AND (pathology_current_observations.patient_id = p.id))) AS hba_result,
      ( SELECT pathology_current_observations.observed_at
             FROM pathology_current_observations
            WHERE (((pathology_current_observations.description_code)::text = 'HBA'::text) AND (pathology_current_observations.patient_id = p.id))) AS hba_observed_at,
      ( SELECT pathology_current_observations.result
             FROM pathology_current_observations
            WHERE (((pathology_current_observations.description_code)::text = 'FER'::text) AND (pathology_current_observations.patient_id = p.id))) AS fer_result,
      ( SELECT pathology_current_observations.observed_at
             FROM pathology_current_observations
            WHERE (((pathology_current_observations.description_code)::text = 'FER'::text) AND (pathology_current_observations.patient_id = p.id))) AS fer_observed_at,
      ( SELECT pathology_current_observations.result
             FROM pathology_current_observations
            WHERE (((pathology_current_observations.description_code)::text = 'PTH'::text) AND (pathology_current_observations.patient_id = p.id))) AS pth_result,
      ( SELECT pathology_current_observations.observed_at
             FROM pathology_current_observations
            WHERE (((pathology_current_observations.description_code)::text = 'PTH'::text) AND (pathology_current_observations.patient_id = p.id))) AS pth_observed_at
     FROM patients p;
  SQL

  create_view "patient_summaries",  sql_definition: <<-SQL
      SELECT patients.id AS patient_id,
      ( SELECT count(*) AS count
             FROM events
            WHERE (events.patient_id = patients.id)) AS events_count,
      ( SELECT count(*) AS count
             FROM clinic_visits
            WHERE (clinic_visits.patient_id = patients.id)) AS clinic_visits_count,
      ( SELECT count(*) AS count
             FROM letter_letters
            WHERE (letter_letters.patient_id = patients.id)) AS letters_count,
      ( SELECT count(*) AS count
             FROM access_profiles
            WHERE (access_profiles.patient_id = patients.id)) AS access_profiles_count,
      ( SELECT count(*) AS count
             FROM modality_modalities
            WHERE (modality_modalities.patient_id = patients.id)) AS modalities_count,
      ( SELECT count(*) AS count
             FROM problem_problems
            WHERE ((problem_problems.deleted_at IS NULL) AND (problem_problems.patient_id = patients.id))) AS problems_count,
      ( SELECT count(*) AS count
             FROM pathology_observation_requests
            WHERE (pathology_observation_requests.patient_id = patients.id)) AS observation_requests_count,
      ( SELECT count(*) AS count
             FROM (medication_prescriptions p
               FULL JOIN medication_prescription_terminations pt ON ((pt.prescription_id = p.id)))
            WHERE ((p.patient_id = patients.id) AND ((pt.terminated_on IS NULL) OR (pt.terminated_on > now())))) AS prescriptions_count,
      ( SELECT count(*) AS count
             FROM letter_contacts
            WHERE (letter_contacts.patient_id = patients.id)) AS contacts_count,
      ( SELECT count(*) AS count
             FROM transplant_recipient_operations
            WHERE (transplant_recipient_operations.patient_id = patients.id)) AS recipient_operations_count
     FROM patients;
  SQL

end
