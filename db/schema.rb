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

ActiveRecord::Schema.define(version: 20150312113937) do

  create_table "addresses", force: :cascade do |t|
    t.string   "street_1",   limit: 255
    t.string   "street_2",   limit: 255
    t.string   "county",     limit: 255
    t.string   "city",       limit: 255
    t.string   "postcode",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "drug_drug_types", force: :cascade do |t|
    t.integer  "drug_id",      limit: 4
    t.integer  "drug_type_id", limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "drug_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "drugs", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "type",       limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "edta_codes", force: :cascade do |t|
    t.integer  "code",        limit: 4
    t.string   "death_cause", limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "esrf_infos", force: :cascade do |t|
    t.integer  "patient_id",  limit: 4
    t.integer  "user_id",     limit: 4
    t.date     "date"
    t.integer  "prd_code_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ethnicities", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exit_site_infections", force: :cascade do |t|
    t.integer  "patient_id",         limit: 4
    t.integer  "user_id",            limit: 4
    t.date     "diagnosis_date"
    t.integer  "organism_1_id",      limit: 4
    t.integer  "organism_2_id",      limit: 4
    t.text     "treatment",          limit: 65535
    t.text     "outcome",            limit: 65535
    t.text     "notes",              limit: 65535
    t.integer  "antibiotic_1_id",    limit: 4
    t.integer  "antibiotic_2_id",    limit: 4
    t.integer  "antibiotic_3_id",    limit: 4
    t.integer  "antibiotic_1_route", limit: 4
    t.integer  "antibiotic_2_route", limit: 4
    t.integer  "antibiotic_3_route", limit: 4
    t.text     "sensitivities",      limit: 65535
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "medication_routes", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "full_name",  limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "medication_versions", force: :cascade do |t|
    t.string   "item_type",      limit: 255,   null: false
    t.integer  "item_id",        limit: 4,     null: false
    t.string   "event",          limit: 255,   null: false
    t.string   "whodunnit",      limit: 255
    t.text     "object",         limit: 65535
    t.text     "object_changes", limit: 65535
    t.datetime "created_at"
  end

  add_index "medication_versions", ["item_type", "item_id"], name: "index_medication_versions_on_item_type_and_item_id", using: :btree

  create_table "medications", force: :cascade do |t|
    t.integer  "patient_id",          limit: 4
    t.integer  "medicate_with_id",    limit: 4
    t.string   "medicate_with_type",  limit: 255
    t.integer  "user_id",             limit: 4
    t.string   "medication_type",     limit: 255
    t.string   "dose",                limit: 255
    t.integer  "medication_route_id", limit: 4
    t.string   "frequency",           limit: 255
    t.text     "notes",               limit: 65535
    t.date     "date"
    t.integer  "provider",            limit: 4
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "medications", ["medicate_with_type", "medicate_with_id"], name: "index_medications_on_medicate_with_type_and_medicate_with_id", using: :btree

  create_table "modality_codes", force: :cascade do |t|
    t.string   "code",       limit: 255
    t.string   "name",       limit: 255
    t.string   "site",       limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "modality_reasons", force: :cascade do |t|
    t.string   "type",        limit: 255
    t.integer  "rr_code",     limit: 4
    t.string   "description", limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organism_codes", force: :cascade do |t|
    t.string   "read_code",  limit: 255
    t.string   "name",       limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "patient_event_types", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",       limit: 255
    t.datetime "deleted_at"
  end

  create_table "patient_events", force: :cascade do |t|
    t.datetime "date_time"
    t.integer  "user_id",               limit: 4
    t.string   "description",           limit: 255
    t.text     "notes",                 limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "patient_event_type_id", limit: 4
    t.integer  "patient_id",            limit: 4
  end

  create_table "patient_modalities", force: :cascade do |t|
    t.integer  "patient_id",         limit: 4
    t.integer  "user_id",            limit: 4
    t.integer  "modality_code_id",   limit: 4
    t.integer  "modality_reason_id", limit: 4
    t.string   "modal_change_type",  limit: 255
    t.text     "notes",              limit: 65535
    t.date     "date"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "patient_problem_versions", force: :cascade do |t|
    t.string   "item_type",      limit: 255,   null: false
    t.integer  "item_id",        limit: 4,     null: false
    t.string   "event",          limit: 255,   null: false
    t.string   "whodunnit",      limit: 255
    t.text     "object",         limit: 65535
    t.text     "object_changes", limit: 65535
    t.datetime "created_at"
  end

  add_index "patient_problem_versions", ["item_type", "item_id"], name: "index_patient_problem_versions_on_item_type_and_item_id", using: :btree

  create_table "patient_problems", force: :cascade do |t|
    t.integer  "patient_id",  limit: 4
    t.string   "description", limit: 255
    t.date     "date"
    t.integer  "user_id",     limit: 4
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "snomed_id",   limit: 255
  end

  add_index "patient_problems", ["deleted_at"], name: "index_patient_problems_on_deleted_at", using: :btree

  create_table "patients", force: :cascade do |t|
    t.string   "nhs_number",                   limit: 255
    t.string   "local_patient_id",             limit: 255
    t.string   "surname",                      limit: 255
    t.string   "forename",                     limit: 255
    t.date     "dob"
    t.boolean  "paediatric_patient_indicator", limit: 1
    t.integer  "sex",                          limit: 4,     default: 9
    t.integer  "current_address_id",           limit: 4
    t.integer  "address_at_diagnosis_id",      limit: 4
    t.string   "gp_practice_code",             limit: 255
    t.string   "pct_org_code",                 limit: 255
    t.string   "hosp_centre_code",             limit: 255
    t.string   "primary_esrf_centre",          limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ethnicity_id",                 limit: 4
    t.datetime "death_date"
    t.integer  "first_edta_code_id",           limit: 4
    t.integer  "second_edta_code_id",          limit: 4
    t.text     "death_details",                limit: 65535
  end

  create_table "peritonitis_episodes", force: :cascade do |t|
    t.integer  "patient_id",           limit: 4
    t.integer  "user_id",              limit: 4
    t.date     "diagnosis_date"
    t.date     "start_treatment_date"
    t.date     "end_treatment_date"
    t.integer  "episode_type_id",      limit: 4
    t.boolean  "catheter_removed",     limit: 1
    t.boolean  "line_break",           limit: 1
    t.boolean  "exit_site_infection",  limit: 1
    t.boolean  "diarrhoea",            limit: 1
    t.boolean  "abdominal_pain",       limit: 1
    t.integer  "fluid_description_id", limit: 4
    t.integer  "white_cell_total",     limit: 4
    t.integer  "white_cell_neutro",    limit: 4
    t.integer  "white_cell_lympho",    limit: 4
    t.integer  "white_cell_degen",     limit: 4
    t.integer  "white_cell_other",     limit: 4
    t.integer  "organism_1_id",        limit: 4
    t.integer  "organism_2_id",        limit: 4
    t.text     "notes",                limit: 65535
    t.integer  "antibiotic_1_id",      limit: 4
    t.integer  "antibiotic_2_id",      limit: 4
    t.integer  "antibiotic_3_id",      limit: 4
    t.integer  "antibiotic_4_id",      limit: 4
    t.integer  "antibiotic_5_id",      limit: 4
    t.integer  "antibiotic_1_route",   limit: 4
    t.integer  "antibiotic_2_route",   limit: 4
    t.integer  "antibiotic_3_route",   limit: 4
    t.integer  "antibiotic_4_route",   limit: 4
    t.integer  "antibiotic_5_route",   limit: 4
    t.text     "sensitivities",        limit: 65535
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "prd_codes", force: :cascade do |t|
    t.string   "code",       limit: 255
    t.string   "term",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  limit: 255,   null: false
    t.integer  "item_id",    limit: 4,     null: false
    t.string   "event",      limit: 255,   null: false
    t.string   "whodunnit",  limit: 255
    t.text     "object",     limit: 65535
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
