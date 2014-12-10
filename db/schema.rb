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

ActiveRecord::Schema.define(version: 20141208160813) do

  create_table "addresses", force: true do |t|
    t.string   "street_1"
    t.string   "street_2"
    t.string   "county"
    t.string   "city"
    t.string   "postcode"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "drugs", force: true do |t|
    t.string   "name"
    t.string   "type"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "drugs_patients", force: true do |t|
    t.integer  "drug_id"
    t.integer  "patient_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ethnicities", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "patient_event_types", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.datetime "deleted_at"
  end

  create_table "patient_events", force: true do |t|
    t.datetime "date_time"
    t.string   "user_id"
    t.string   "description"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "patient_event_type_id"
    t.integer  "patient_id"
  end

  create_table "patient_medications", force: true do |t|
    t.integer  "patient_id"
    t.integer  "medication_id"
    t.integer  "user_id"
    t.string   "medication_type"
    t.string   "dose"
    t.integer  "route"
    t.string   "frequency"
    t.text     "notes"
    t.date     "date"
    t.integer  "provider"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "patients", force: true do |t|
    t.string   "nhs_number"
    t.string   "local_patient_id"
    t.string   "surname"
    t.string   "forename"
    t.date     "dob"
    t.boolean  "paediatric_patient_indicator"
    t.integer  "sex",                          default: 9
    t.integer  "current_address_id"
    t.integer  "address_at_diagnosis_id"
    t.string   "gp_practice_code"
    t.string   "pct_org_code"
    t.string   "hosp_centre_code"
    t.string   "primary_esrf_centre"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ethnicity_id"
  end

  create_table "problems", force: true do |t|
    t.integer  "patient_id"
    t.string   "description"
    t.date     "date"
    t.integer  "user_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
