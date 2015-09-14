# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150903143922) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string   "street_1"
    t.string   "street_2"
    t.string   "county"
    t.string   "city"
    t.string   "postcode"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
  end

  create_table "bag_types", force: :cascade do |t|
    t.string   "manufacturer"
    t.string   "description"
    t.decimal  "glucose_grams_per_litre", precision: 4, scale: 1
    t.boolean  "amino_acid"
    t.boolean  "icodextrin"
    t.boolean  "low_glucose_degradation"
    t.boolean  "low_sodium"
    t.integer  "sodium_mmole_l"
    t.integer  "lactate_mmole_l"
    t.integer  "bicarbonate_mmole_l"
    t.decimal  "calcium_mmole_l",         precision: 3, scale: 2
    t.decimal  "magnesium_mmole_l",       precision: 3, scale: 2
    t.datetime "deleted_at"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "bag_types", ["deleted_at"], name: "index_bag_types_on_deleted_at", using: :btree

  create_table "clinic_visits", force: :cascade do |t|
    t.integer  "patient_id"
    t.datetime "date",          null: false
    t.float    "height"
    t.float    "weight"
    t.integer  "systolic_bp"
    t.integer  "diastolic_bp"
    t.string   "urine_blood"
    t.string   "urine_protein"
    t.text     "notes"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "clinic_visits", ["patient_id"], name: "index_clinic_visits_on_patient_id", using: :btree

  create_table "doctors", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "code"
    t.integer  "address_id"
    t.string   "practitioner_type", null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "doctors", ["code"], name: "index_doctors_on_code", unique: true, using: :btree

  create_table "doctors_practices", id: false, force: :cascade do |t|
    t.integer "doctor_id"
    t.integer "practice_id"
  end

  add_index "doctors_practices", ["doctor_id", "practice_id"], name: "index_doctors_practices", using: :btree

  create_table "drug_drug_types", force: :cascade do |t|
    t.integer  "drug_id"
    t.integer  "drug_type_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "drug_drug_types", ["drug_id", "drug_type_id"], name: "index_drug_drug_types_on_drug_id_and_drug_type_id", unique: true, using: :btree

  create_table "drug_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "drugs", force: :cascade do |t|
    t.string   "name"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "edta_codes", force: :cascade do |t|
    t.integer  "code"
    t.string   "death_cause"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "episode_types", force: :cascade do |t|
    t.string   "term"
    t.string   "definition"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "esrf_infos", force: :cascade do |t|
    t.integer  "patient_id"
    t.date     "date"
    t.integer  "prd_code_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ethnicities", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_types", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.datetime "deleted_at"
  end

  create_table "events", force: :cascade do |t|
    t.datetime "date_time"
    t.string   "description"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_type_id"
    t.integer  "patient_id"
  end

  create_table "exit_site_infections", force: :cascade do |t|
    t.integer  "patient_id"
    t.date     "diagnosis_date"
    t.text     "treatment"
    t.text     "outcome"
    t.text     "notes"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "fluid_descriptions", force: :cascade do |t|
    t.string   "description"
    t.datetime "deleted_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "infection_organisms", force: :cascade do |t|
    t.integer  "organism_code_id"
    t.text     "sensitivity"
    t.integer  "infectable_id"
    t.string   "infectable_type"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "infection_organisms", ["infectable_type", "infectable_id"], name: "index_infection_organisms_on_infectable_type_and_infectable_id", using: :btree
  add_index "infection_organisms", ["organism_code_id", "infectable_id", "infectable_type"], name: "index_infection_organisms", unique: true, using: :btree

  create_table "letter_descriptions", force: :cascade do |t|
    t.string   "text",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "letters", force: :cascade do |t|
    t.string   "state",                 default: "draft",  null: false
    t.string   "type",                                     null: false
    t.integer  "letter_description_id",                    null: false
    t.text     "problems"
    t.text     "medications"
    t.text     "body"
    t.string   "signature"
    t.string   "recipient",             default: "doctor", null: false
    t.string   "additional_recipients"
    t.integer  "doctor_id"
    t.integer  "patient_id"
    t.integer  "clinic_visit_id"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "author_id"
    t.integer  "reviewer_id"
    t.integer  "recipient_address_id"
  end

  add_index "letters", ["author_id"], name: "index_letters_on_author_id", using: :btree
  add_index "letters", ["clinic_visit_id"], name: "index_letters_on_clinic_visit_id", using: :btree
  add_index "letters", ["doctor_id"], name: "index_letters_on_doctor_id", using: :btree
  add_index "letters", ["letter_description_id"], name: "index_letters_on_letter_description_id", using: :btree
  add_index "letters", ["patient_id"], name: "index_letters_on_patient_id", using: :btree
  add_index "letters", ["recipient_address_id"], name: "index_letters_on_recipient_address_id", using: :btree
  add_index "letters", ["reviewer_id"], name: "index_letters_on_reviewer_id", using: :btree
  add_index "letters", ["type"], name: "index_letters_on_type", using: :btree

  create_table "medication_routes", force: :cascade do |t|
    t.string   "name"
    t.string   "full_name"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "medication_versions", force: :cascade do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.text     "object_changes"
    t.datetime "created_at"
  end

  add_index "medication_versions", ["item_type", "item_id"], name: "index_medication_versions_on_item_type_and_item_id", using: :btree

  create_table "medications", force: :cascade do |t|
    t.integer  "patient_id"
    t.integer  "medicatable_id"
    t.string   "medicatable_type"
    t.integer  "treatable_id"
    t.string   "treatable_type"
    t.string   "dose"
    t.integer  "medication_route_id"
    t.string   "frequency"
    t.text     "notes"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "provider"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "medications", ["deleted_at"], name: "index_medications_on_deleted_at", using: :btree
  add_index "medications", ["medicatable_type", "medicatable_id"], name: "index_medications_on_medicatable_type_and_medicatable_id", using: :btree
  add_index "medications", ["treatable_type", "treatable_id"], name: "index_medications_on_treatable_type_and_treatable_id", using: :btree

  create_table "modalities", force: :cascade do |t|
    t.integer  "patient_id"
    t.integer  "modality_code_id"
    t.integer  "modality_reason_id"
    t.string   "modal_change_type"
    t.text     "notes"
    t.date     "start_date"
    t.date     "termination_date"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "modality_codes", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.string   "site"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "modality_reasons", force: :cascade do |t|
    t.string   "type"
    t.integer  "rr_code"
    t.string   "description"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organism_codes", force: :cascade do |t|
    t.string   "read_code"
    t.string   "name"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "patients", force: :cascade do |t|
    t.string   "nhs_number"
    t.string   "local_patient_id"
    t.string   "surname"
    t.string   "forename"
    t.date     "birth_date"
    t.boolean  "paediatric_patient_indicator"
    t.integer  "sex"
    t.integer  "ethnicity_id"
    t.integer  "current_address_id"
    t.integer  "address_at_diagnosis_id"
    t.string   "gp_practice_code"
    t.string   "pct_org_code"
    t.string   "hosp_centre_code"
    t.string   "primary_esrf_centre"
    t.date     "death_date"
    t.integer  "first_edta_code_id"
    t.integer  "second_edta_code_id"
    t.text     "death_details"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "practice_id"
    t.integer  "doctor_id"
  end

  add_index "patients", ["doctor_id"], name: "index_patients_on_doctor_id", using: :btree

  create_table "pd_regime_bags", force: :cascade do |t|
    t.integer  "pd_regime_id"
    t.integer  "bag_type_id"
    t.integer  "volume"
    t.integer  "per_week"
    t.boolean  "monday"
    t.boolean  "tuesday"
    t.boolean  "wednesday"
    t.boolean  "thursday"
    t.boolean  "friday"
    t.boolean  "saturday"
    t.boolean  "sunday"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "pd_regimes", force: :cascade do |t|
    t.integer  "patient_id"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "treatment"
    t.string   "type"
    t.integer  "glucose_ml_percent_1_36"
    t.integer  "glucose_ml_percent_2_27"
    t.integer  "glucose_ml_percent_3_86"
    t.integer  "amino_acid_ml"
    t.integer  "icodextrin_ml"
    t.boolean  "add_hd"
    t.integer  "last_fill_ml"
    t.boolean  "add_manual_exchange"
    t.boolean  "tidal_indicator"
    t.integer  "tidal_percentage"
    t.integer  "no_cycles_per_apd"
    t.integer  "overnight_pd_ml"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "peritonitis_episodes", force: :cascade do |t|
    t.integer  "patient_id"
    t.date     "diagnosis_date"
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
  end

  create_table "practices", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "code"
    t.integer  "address_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "prd_codes", force: :cascade do |t|
    t.string   "code"
    t.string   "term"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "problem_versions", force: :cascade do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.text     "object_changes"
    t.datetime "created_at"
  end

  add_index "problem_versions", ["item_type", "item_id"], name: "index_problem_versions_on_item_type_and_item_id", using: :btree

  create_table "problems", force: :cascade do |t|
    t.integer  "patient_id"
    t.string   "description"
    t.date     "date"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "snomed_id"
    t.string   "snomed_description"
  end

  add_index "problems", ["deleted_at"], name: "index_problems_on_deleted_at", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", id: false, force: :cascade do |t|
    t.integer "role_id"
    t.integer "user_id"
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "approved",               default: false
    t.string   "username"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "last_activity_at"
    t.datetime "expired_at"
    t.string   "professional_position"
    t.string   "signature"
  end

  add_index "users", ["approved"], name: "index_users_on_approved", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["expired_at"], name: "index_users_on_expired_at", using: :btree
  add_index "users", ["last_activity_at"], name: "index_users_on_last_activity_at", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  add_foreign_key "letters", "addresses", column: "recipient_address_id"
  add_foreign_key "letters", "users", column: "author_id"
  add_foreign_key "letters", "users", column: "reviewer_id"
end
