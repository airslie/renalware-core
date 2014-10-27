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

ActiveRecord::Schema.define(version: 20141027105619) do

  create_table "addresses", force: true do |t|
    t.string   "street_1"
    t.string   "street_2"
    t.string   "county"
    t.string   "city"
    t.string   "postcode"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "encounter_events", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "enc_date"
    t.string   "staff_name"
    t.string   "enc_type"
    t.string   "enc_descript"
    t.text     "enc_notes"
  end

<<<<<<< HEAD
=======
  create_table "encounterdata", primary_key: "encounter_id", force: true do |t|
    t.integer   "enczid",        limit: 3
    t.timestamp "encmodifstamp",                                    null: false
    t.datetime  "encaddstamp"
    t.string    "encuser",       limit: 20
    t.string    "encmodal",      limit: 20
    t.date      "encdate"
    t.string    "enctime",       limit: 20
    t.string    "enctype",       limit: 50
    t.string    "encdescr"
    t.text      "enctext"
    t.integer   "bpsyst",        limit: 1
    t.integer   "bpdiast",       limit: 1
    t.decimal   "weight",                   precision: 4, scale: 1
    t.decimal   "height",                   precision: 3, scale: 2
    t.text      "notes"
    t.string    "staffname",     limit: 50
  end

  add_index "encounterdata", ["enczid"], name: "enczid", using: :btree

  create_table "esddata", primary_key: "esd_id", force: true do |t|
    t.integer  "esdzid",            limit: 3,                           default: 0, null: false
    t.datetime "esdstamp"
    t.date     "esddate"
    t.string   "esdstatus",         limit: 20
    t.date     "esdstartdate"
    t.date     "esdmodifdate"
    t.datetime "esdmodifdt"
    t.string   "esdregime",         limit: 100
    t.string   "prescriber",        limit: 20
    t.integer  "unitsperweek",      limit: 3
    t.decimal  "unitsperwkperkg",               precision: 5, scale: 1
    t.string   "lastirondose",      limit: 12
    t.string   "lastirondosetype",  limit: 12
    t.date     "lastirondosedate"
    t.string   "lastirondosebatch", limit: 12
    t.text     "esdcomments"
    t.string   "administrator",     limit: 12
  end

  add_index "esddata", ["esddate"], name: "esddate", using: :btree
  add_index "esddata", ["esdstatus"], name: "esdstatus", using: :btree
  add_index "esddata", ["esdzid"], name: "esdzid", unique: true, using: :btree

  create_table "esrfcauses", primary_key: "esrfcause_id", force: true do |t|
    t.string "edtacode",  limit: 2
    t.string "esrfcause"
  end

  add_index "esrfcauses", ["edtacode"], name: "edtacode", using: :btree

  create_table "esrfdata", primary_key: "esrf_id", force: true do |t|
    t.integer  "esrfzid",              limit: 3,                           default: 0, null: false
    t.datetime "esrfstamp"
    t.datetime "esrfmodifstamp"
    t.date     "esrfdate"
    t.date     "firstseendate"
    t.decimal  "esrfweight",                       precision: 4, scale: 1
    t.string   "EDTAcode",             limit: 2
    t.string   "EDTAtext",             limit: 120
    t.string   "SecondCause1",         limit: 120
    t.integer  "rreg_prdcode",         limit: 2
    t.date     "rreg_prddate"
    t.string   "Angina",               limit: 1
    t.string   "PreviousMIlast90d",    limit: 1
    t.string   "PreviousMIover90d",    limit: 1
    t.string   "PreviousCAGB",         limit: 1
    t.string   "EpisodeHeartFailure",  limit: 1
    t.string   "Smoking",              limit: 1
    t.string   "COPD",                 limit: 1
    t.string   "CVDsympt",             limit: 1
    t.string   "DiabetesNotCauseESRF", limit: 1
    t.string   "Malignancy",           limit: 1
    t.string   "LiverDisease",         limit: 1
    t.string   "Claudication",         limit: 1
    t.string   "IschNeuropathUlcers",  limit: 1
    t.string   "AngioplastyNonCoron",  limit: 1
    t.string   "AmputationPVD",        limit: 1
  end

  add_index "esrfdata", ["esrfdate"], name: "esrfdate", using: :btree
  add_index "esrfdata", ["esrfzid"], name: "esrfzid", unique: true, using: :btree
  add_index "esrfdata", ["rreg_prdcode"], name: "rreg_prdcode", using: :btree

  create_table "ethniccodes", id: false, force: true do |t|
    t.string "ethnicity", limit: 30
    t.string "readcode",  limit: 6
  end

  add_index "ethniccodes", ["ethnicity"], name: "ethnicity", using: :btree

  create_table "ethnicityfixdata", id: false, force: true do |t|
    t.string  "ethnicity", limit: 50
    t.integer "patcount",             default: 0, null: false
  end

  create_table "eventlogs", primary_key: "eventlog_id", force: true do |t|
    t.timestamp "eventstamp",              null: false
    t.string    "eventuser",   limit: 20
    t.integer   "event_uid",   limit: 2
    t.integer   "eventzid",    limit: 3
    t.integer   "session_id",  limit: 3
    t.text      "type",        limit: 255
    t.integer   "session_ipn"
  end

  add_index "eventlogs", ["event_uid"], name: "uid", using: :btree
  add_index "eventlogs", ["eventzid"], name: "eventzid", using: :btree

  create_table "exitsitedata", primary_key: "exitsitedata_id", force: true do |t|
    t.integer  "exitsitezid",   limit: 3
    t.date     "infectiondate"
    t.string   "organism1",     limit: 50
    t.string   "organism2",     limit: 50
    t.string   "treatment"
    t.string   "outcome"
    t.string   "exitsitenotes"
    t.datetime "addstamp"
    t.datetime "modifstamp"
  end

  add_index "exitsitedata", ["exitsitezid"], name: "exitsitezid", using: :btree

  create_table "gpCDAlogs", primary_key: "log_id", force: true do |t|
    t.timestamp "logstamp",                                                 null: false
    t.date      "logadddate"
    t.integer   "logzid",          limit: 3,  default: 0,                   null: false
    t.integer   "logletter_id",    limit: 3,  default: 0,                   null: false
    t.string    "loghospno",       limit: 12
    t.integer   "loguid",          limit: 2,  default: 0,                   null: false
    t.string    "loguser",         limit: 20, default: "loguser",           null: false
    t.string    "logpracticecode", limit: 12,                               null: false
    t.string    "logdescr",        limit: 90, default: "letterdescription", null: false
    t.string    "loglettertype",   limit: 20
  end

  add_index "gpcdalogs", ["logletter_id"], name: "logletter_id", using: :btree
  add_index "gpcdalogs", ["logpracticecode"], name: "logpracticecode", using: :btree
  add_index "gpcdalogs", ["loguid"], name: "loguid", using: :btree
  add_index "gpcdalogs", ["logzid"], name: "logzid", using: :btree

  create_table "gpemaillogs", primary_key: "log_id", force: true do |t|
    t.timestamp "logstamp",                                                 null: false
    t.date      "logadddate"
    t.integer   "logzid",          limit: 3,  default: 0,                   null: false
    t.integer   "logletter_id",    limit: 3,  default: 0,                   null: false
    t.string    "loghospno",       limit: 12
    t.integer   "loguid",          limit: 2,  default: 0,                   null: false
    t.string    "loguser",         limit: 20, default: "loguser",           null: false
    t.string    "logpracticecode", limit: 12,                               null: false
    t.string    "logemail",        limit: 60
    t.string    "logdescr",        limit: 90, default: "letterdescription", null: false
    t.string    "loglettertype",   limit: 20
    t.string    "logfilename",     limit: 60
    t.text      "loghtml"
  end

  add_index "gpemaillogs", ["logletter_id"], name: "logletter_id", using: :btree
  add_index "gpemaillogs", ["logpracticecode"], name: "logpracticecode", using: :btree
  add_index "gpemaillogs", ["loguid"], name: "loguid", using: :btree
  add_index "gpemaillogs", ["logzid"], name: "logzid", using: :btree

  create_table "hddryweightdata", primary_key: "drywt_id", force: true do |t|
    t.integer  "drywtzid",        limit: 3
    t.datetime "addstamp"
    t.integer  "adduid",          limit: 2
    t.date     "drywtassessdate"
    t.decimal  "dryweight",                  precision: 4, scale: 1
    t.string   "drywtassessor",   limit: 50
  end

  add_index "hddryweightdata", ["drywtzid"], name: "drywtzid", using: :btree

  create_table "hdholsdata", primary_key: "hdholsdata_id", force: true do |t|
    t.integer  "holzid",    limit: 3
    t.datetime "addstamp"
    t.date     "startdate"
    t.date     "enddate"
    t.string   "holnotes"
    t.integer  "adduid",    limit: 2
    t.string   "adduser",   limit: 30
  end

  add_index "hdholsdata", ["holzid"], name: "zid", using: :btree

  create_table "hdpatdata", id: false, force: true do |t|
    t.integer   "hdpatzid",           limit: 3,                                          null: false
    t.timestamp "hdaddstamp",                                                            null: false
    t.datetime  "hdmodifstamp"
    t.string    "currsite",           limit: 6
    t.string    "currsched",          limit: 9
    t.string    "hdtype",             limit: 8,                           default: "HD"
    t.string    "needlesize",         limit: 10
    t.string    "singleneedle",       limit: 1
    t.string    "hours",              limit: 10
    t.string    "dialyser",           limit: 20
    t.string    "dialysate",          limit: 20
    t.integer   "flowrate",           limit: 2
    t.boolean   "dialK"
    t.decimal   "dialCa",                         precision: 3, scale: 1
    t.decimal   "dialTemp",                       precision: 3, scale: 1
    t.string    "dialBicarb",         limit: 30
    t.string    "dialNaProfiling",    limit: 1
    t.integer   "dialNa1sthalf",      limit: 1
    t.integer   "dialNa2ndhalf",      limit: 1
    t.string    "anticoagtype",       limit: 30
    t.string    "anticoagloaddose",   limit: 20
    t.string    "anticoaghourlydose", limit: 20
    t.string    "anticoagstoptime",   limit: 30
    t.string    "prescriber",         limit: 30
    t.date      "prescriptdate"
    t.string    "esdflag",            limit: 1
    t.string    "ironflag",           limit: 1
    t.string    "namednurse",         limit: 20
    t.string    "warfarinflag",       limit: 1
    t.decimal   "dryweight",                      precision: 4, scale: 1
    t.date      "drywtassessdate"
    t.string    "drywtassessor",      limit: 30
    t.string    "transport",          limit: 1
    t.string    "transportdecider",   limit: 30
    t.date      "transportdate"
    t.string    "transporttype",      limit: 100
    t.string    "currslot",           limit: 3
    t.string    "prefsite",           limit: 20
    t.string    "prefsched",          limit: 9
    t.string    "prefslot",           limit: 3
    t.date      "prefdate"
    t.string    "prefnotes"
    t.string    "carelevelrequired",  limit: 40
    t.date      "careleveldate"
    t.integer   "lastavg_syst",       limit: 2
    t.integer   "lastavg_diast",      limit: 2
    t.string    "cannulationtype",    limit: 12
    t.integer   "lastavg_systpost",   limit: 2
    t.integer   "lastavg_diastpost",  limit: 2
  end

  add_index "hdpatdata", ["currsite"], name: "hdsitecode", using: :btree
  add_index "hdpatdata", ["hdpatzid"], name: "hdpatzid", unique: true, using: :btree

  create_table "hdprofilehxdata", primary_key: "hdprofile_id", force: true do |t|
    t.integer   "hdprofilezid",       limit: 3,                                          null: false
    t.timestamp "hdprofileaddstamp",                                                     null: false
    t.string    "currsite",           limit: 6
    t.string    "currsched",          limit: 9
    t.string    "hdtype",             limit: 8,                           default: "HD"
    t.string    "needlesize",         limit: 10
    t.string    "singleneedle",       limit: 1
    t.string    "hours",              limit: 10
    t.string    "dialyser",           limit: 20
    t.string    "dialysate",          limit: 20
    t.integer   "flowrate",           limit: 2
    t.boolean   "dialK"
    t.decimal   "dialCa",                         precision: 3, scale: 1
    t.decimal   "dialTemp",                       precision: 3, scale: 1
    t.string    "dialBicarb",         limit: 30
    t.string    "dialNaProfiling",    limit: 1
    t.integer   "dialNa1sthalf",      limit: 1
    t.integer   "dialNa2ndhalf",      limit: 1
    t.string    "anticoagtype",       limit: 30
    t.string    "anticoagloaddose",   limit: 20
    t.string    "anticoaghourlydose", limit: 20
    t.string    "anticoagstoptime",   limit: 30
    t.string    "prescriber",         limit: 30
    t.date      "prescriptdate"
    t.string    "esdflag",            limit: 1
    t.string    "ironflag",           limit: 1
    t.string    "namednurse",         limit: 20
    t.string    "warfarinflag",       limit: 1
    t.decimal   "dryweight",                      precision: 4, scale: 1
    t.date      "drywtassessdate"
    t.string    "drywtassessor",      limit: 30
    t.string    "transport",          limit: 1
    t.string    "transportdecider",   limit: 30
    t.date      "transportdate"
    t.string    "transporttype",      limit: 100
    t.string    "currslot",           limit: 3
    t.string    "prefsite",           limit: 20
    t.string    "prefsched",          limit: 9
    t.string    "prefslot",           limit: 3
    t.date      "prefdate"
    t.string    "prefnotes"
    t.string    "carelevelrequired",  limit: 40
    t.date      "careleveldate"
    t.string    "cannulationtype",    limit: 12
  end

  add_index "hdprofilehxdata", ["hdprofilezid"], name: "hdprofilezid", using: :btree

  create_table "hdsessiondata", primary_key: "hdsession_id", force: true do |t|
    t.integer   "hdsesszid",          limit: 3
    t.datetime  "hdsessaddstamp"
    t.timestamp "hdsessmodifstamp",                                                       null: false
    t.string    "hdsessuser",         limit: 30
    t.date      "hdsessdate"
    t.string    "sitecode",           limit: 20
    t.string    "schedule",           limit: 9
    t.string    "hdtype",             limit: 3,                           default: "HD"
    t.string    "modalcode",          limit: 30
    t.string    "timeon",             limit: 6
    t.string    "timeoff",            limit: 6
    t.decimal   "wt_pre",                         precision: 4, scale: 1
    t.decimal   "wt_post",                        precision: 4, scale: 1
    t.decimal   "weightchange",                   precision: 3, scale: 1
    t.integer   "pulse_pre",          limit: 1
    t.integer   "pulse_post",         limit: 1
    t.integer   "syst_pre",           limit: 2
    t.integer   "syst_post",          limit: 2
    t.integer   "diast_pre",          limit: 2
    t.integer   "diast_post",         limit: 2
    t.decimal   "temp_pre",                       precision: 3, scale: 1
    t.decimal   "temp_post",                      precision: 3, scale: 1
    t.string    "BM_pre",             limit: 5
    t.string    "BM_post",            limit: 5
    t.integer   "AP",                 limit: 2
    t.integer   "VP",                 limit: 2
    t.decimal   "fluidremoved",                   precision: 2, scale: 1
    t.integer   "bloodflow",          limit: 2
    t.decimal   "UFR",                            precision: 3, scale: 2
    t.integer   "machineURR",         limit: 1
    t.decimal   "machineKTV",                     precision: 2, scale: 1
    t.string    "machineNo",          limit: 5
    t.string    "litresproc",         limit: 10
    t.text      "evaluation",         limit: 255
    t.string    "signon",             limit: 20
    t.string    "signoff",            limit: 20
    t.boolean   "submitflag",                                             default: false
    t.boolean   "firstuseflag"
    t.integer   "subsfluidpct",       limit: 1
    t.decimal   "subsgoal",                       precision: 4, scale: 2
    t.decimal   "subsrate",                       precision: 4, scale: 2
    t.decimal   "subsvol",                        precision: 4, scale: 2
    t.string    "access",             limit: 50
    t.boolean   "dressingchangeflag"
    t.boolean   "mrsaswabflag",                                           default: false
    t.string    "accesssitestatus",   limit: 24
  end

  add_index "hdsessiondata", ["hdsessdate"], name: "hdsessdate", using: :btree
  add_index "hdsessiondata", ["hdsesszid"], name: "hdsessrid", using: :btree

  create_table "homehdassessdata", primary_key: "homehdassess_id", force: true do |t|
    t.timestamp "homehdassessstamp",                null: false
    t.integer   "homehdassesszid",      limit: 3
    t.integer   "homehdassess_uid",     limit: 2
    t.string    "homehdassessuser",     limit: 20
    t.date      "referraldate"
    t.string    "selfcarelevel",        limit: 40
    t.text      "selfcarenotes"
    t.text      "medicalassess"
    t.date      "medicaldate"
    t.text      "technicalassess"
    t.date      "technicaldate"
    t.text      "socialworkassess"
    t.date      "socialworkdate"
    t.text      "counsellorassess"
    t.date      "counsellordate"
    t.text      "fullindepconfirm"
    t.date      "fullindepconfirmdate"
    t.string    "programmetype",        limit: 40
    t.string    "carername",            limit: 100
    t.text      "carernotes"
    t.date      "acceptancedate"
    t.date      "equipinstalldate"
    t.date      "firstdeliverydate"
    t.date      "trainingstartdate"
    t.date      "firstindepdialdate"
    t.text      "assessmentnotes"
    t.string    "assessor",             limit: 100
    t.string    "housingtype",          limit: 30
    t.string    "letterwrittentype",    limit: 30
    t.date      "letterwrittendate"
    t.string    "letterrecvtype",       limit: 30
    t.date      "letterrecvdate"
  end

  add_index "homehdassessdata", ["homehdassesszid"], name: "homehdassesszid", unique: true, using: :btree

  create_table "immunosupprepeatrxdata", primary_key: "import_id", force: true do |t|
    t.timestamp "importstamp",                              null: false
    t.date      "importdate"
    t.integer   "importuid",     limit: 3
    t.string    "importuser",    limit: 20
    t.integer   "rowno",         limit: 2
    t.integer   "evolution_id",  limit: 3,  default: 0,     null: false
    t.string    "firstname",     limit: 30
    t.string    "surname",       limit: 30
    t.date      "birthdate"
    t.string    "prescriber",    limit: 30
    t.date      "nextdelivdate"
    t.string    "hospital",      limit: 30
    t.string    "hospno",        limit: 12
    t.string    "nhsno",         limit: 12
    t.string    "patientdx",     limit: 24
    t.boolean   "runflag",                  default: false
    t.integer   "runuid",        limit: 3
    t.string    "runuser",       limit: 20
    t.datetime  "rundt"
  end

  add_index "immunosupprepeatrxdata", ["evolution_id"], name: "evolution_id", using: :btree
  add_index "immunosupprepeatrxdata", ["hospno", "nextdelivdate"], name: "hospno_2", unique: true, using: :btree
  add_index "immunosupprepeatrxdata", ["hospno"], name: "hospno", using: :btree
  add_index "immunosupprepeatrxdata", ["runflag"], name: "runflag", using: :btree

  create_table "immunosupprxforms", primary_key: "rxform_id", force: true do |t|
    t.timestamp "rxformstamp",                                    null: false
    t.date      "rxformdate"
    t.integer   "rxformzid",    limit: 3,  default: 0,            null: false
    t.string    "rxformhospno", limit: 12
    t.string    "med_ids"
    t.integer   "rxformuid",    limit: 2,  default: 0,            null: false
    t.string    "rxformuser",   limit: 20, default: "rxformuser", null: false
    t.string    "rxformmeds"
    t.text      "rxformhtml"
  end

  add_index "immunosupprxforms", ["med_ids"], name: "med_ids", using: :btree
  add_index "immunosupprxforms", ["rxformdate"], name: "rxformdate", using: :btree
  add_index "immunosupprxforms", ["rxformhospno"], name: "rxformhospno", using: :btree
  add_index "immunosupprxforms", ["rxformuid"], name: "rxformuid", using: :btree
  add_index "immunosupprxforms", ["rxformzid"], name: "rxformzid", using: :btree

  create_table "immunosupprxmedlogs", primary_key: "log_id", force: true do |t|
    t.timestamp "logstamp",                                 null: false
    t.date      "logdate"
    t.integer   "logzid",    limit: 3,  default: 0,         null: false
    t.string    "loghospno", limit: 12
    t.integer   "rxform_id", limit: 3,  default: 0,         null: false
    t.integer   "med_id",               default: 0,         null: false
    t.integer   "loguid",    limit: 2,  default: 0,         null: false
    t.string    "loguser",   limit: 20, default: "loguser", null: false
  end

  add_index "immunosupprxmedlogs", ["loghospno"], name: "loghospno", using: :btree
  add_index "immunosupprxmedlogs", ["loguid"], name: "loguid", using: :btree
  add_index "immunosupprxmedlogs", ["logzid"], name: "logzid", using: :btree
  add_index "immunosupprxmedlogs", ["med_id"], name: "med_id", unique: true, using: :btree
  add_index "immunosupprxmedlogs", ["rxform_id"], name: "rxform_id", using: :btree

  create_table "irondosedata", primary_key: "irondose_id", force: true do |t|
    t.integer  "irondosezid",      limit: 3,   default: 0, null: false
    t.integer  "irondoseuid",      limit: 2,   default: 0, null: false
    t.string   "irondoseuser",     limit: 20
    t.datetime "irondosestamp"
    t.date     "irondosedate"
    t.string   "irondose",         limit: 12
    t.string   "irondosetype",     limit: 12
    t.string   "irondosebatch",    limit: 12
    t.text     "irondosecomments", limit: 255
  end

  add_index "irondosedata", ["irondosebatch"], name: "irondosebatch", using: :btree
  add_index "irondosedata", ["irondosedate"], name: "irondosedate", using: :btree
  add_index "irondosedata", ["irondosezid"], name: "irondosezid", using: :btree

  create_table "ixworkupdata", primary_key: "ixworkupdata_id", force: true do |t|
    t.integer  "ixworkupzid",      limit: 3
    t.string   "ixworkupuser",     limit: 30
    t.datetime "ixworkupaddstamp"
    t.string   "ixworkupmodal",    limit: 50
    t.date     "ixworkupdate"
    t.string   "ixworkuptype",     limit: 100
    t.string   "ixworkupresults"
    t.text     "ixworkuptext"
    t.boolean  "currflag"
  end

  add_index "ixworkupdata", ["currflag"], name: "currflag", using: :btree
  add_index "ixworkupdata", ["ixworkuptype"], name: "ixworkuptype", using: :btree
  add_index "ixworkupdata", ["ixworkupuser"], name: "ixworkupuid", using: :btree
  add_index "ixworkupdata", ["ixworkupzid"], name: "ixworkupzid", using: :btree

  create_table "letterccdata", primary_key: "lettercc_id", force: true do |t|
    t.timestamp "ccstamp",                                  null: false
    t.string    "ccstatus",    limit: 5,  default: "draft"
    t.integer   "cc_uid",      limit: 2
    t.string    "ccuser",      limit: 20
    t.integer   "recip_uid",   limit: 2
    t.string    "recipuser",   limit: 20
    t.integer   "ccletter_id", limit: 3
    t.integer   "cczid",       limit: 3
    t.datetime  "readstamp"
    t.datetime  "sentstamp"
  end

  add_index "letterccdata", ["cc_uid"], name: "cc_uid", using: :btree
  add_index "letterccdata", ["ccletter_id"], name: "ccletter_id", using: :btree
  add_index "letterccdata", ["ccstatus"], name: "ccstatus", using: :btree
  add_index "letterccdata", ["cczid"], name: "cczid", using: :btree
  add_index "letterccdata", ["recip_uid"], name: "recip_uid", using: :btree

  create_table "letterdata", primary_key: "letter_id", force: true do |t|
    t.integer  "letterzid",       limit: 3
    t.string   "letthospno",      limit: 7
    t.integer  "lettuid",         limit: 2
    t.string   "lettuser",        limit: 20
    t.datetime "lettaddstamp"
    t.datetime "lettmodifstamp"
    t.integer  "authorid",        limit: 2
    t.integer  "typistid",        limit: 2
    t.string   "typistinits",     limit: 6
    t.date     "letterdate"
    t.string   "lettertype",      limit: 9,                           default: "clinic"
    t.date     "clinicdate"
    t.date     "printdate"
    t.string   "status",          limit: 9
    t.integer  "lettertype_id",   limit: 2
    t.string   "lettdescr",       limit: 100
    t.string   "patlastfirst",    limit: 50
    t.string   "authorlastfirst", limit: 40
    t.string   "authorsig",       limit: 50
    t.string   "position",        limit: 50
    t.string   "recipname",       limit: 100
    t.text     "recipient"
    t.string   "salut",           limit: 60
    t.string   "patref"
    t.string   "pataddr"
    t.text     "lettproblems"
    t.text     "lettmeds"
    t.text     "lettresults"
    t.integer  "lettBPsyst",      limit: 2
    t.integer  "lettBPdiast",     limit: 1
    t.decimal  "lettWeight",                  precision: 4, scale: 1
    t.decimal  "lettHeight",                  precision: 3, scale: 2
    t.string   "letturine_blood", limit: 6
    t.string   "letturine_prot",  limit: 6
    t.string   "lettallergies",   limit: 200
    t.text     "cctext"
    t.boolean  "printstage",                                          default: false
    t.string   "modalstamp",      limit: 15
    t.text     "elecsig",         limit: 255
    t.integer  "admissionid",     limit: 3
    t.date     "admdate"
    t.string   "admward",         limit: 20
    t.date     "dischdate"
    t.string   "dischdest",       limit: 100
    t.string   "admconsultant",   limit: 50
    t.string   "reason"
    t.string   "deathcause"
    t.boolean  "archiveflag",                                         default: false
    t.date     "typeddate"
    t.date     "reviewdate"
    t.integer  "wordcount",       limit: 2,                           default: 0
  end

  add_index "letterdata", ["admdate"], name: "admdate", using: :btree
  add_index "letterdata", ["admissionid"], name: "admissionid", using: :btree
  add_index "letterdata", ["archiveflag"], name: "archiveflag", using: :btree
  add_index "letterdata", ["authorid"], name: "authorid", using: :btree
  add_index "letterdata", ["letterzid"], name: "zid", using: :btree
  add_index "letterdata", ["lettuid"], name: "lettuid", using: :btree
  add_index "letterdata", ["lettuser"], name: "lettuser", using: :btree
  add_index "letterdata", ["patlastfirst"], name: "patlastfirst", using: :btree
  add_index "letterdata", ["printstage"], name: "printstage", using: :btree
  add_index "letterdata", ["typistid"], name: "typistid", using: :btree

  create_table "letterdescrlist", primary_key: "lettertype_id", force: true do |t|
    t.integer  "letterdescruid",   limit: 2
    t.string   "letterdescr",      limit: 100
    t.datetime "letterdescrstamp"
    t.boolean  "clinicflag",                   default: false, null: false
  end

  add_index "letterdescrlist", ["letterdescruid"], name: "lettertypeuid", using: :btree

  create_table "letterheadlist", primary_key: "letterhead_id", force: true do |t|
    t.timestamp "addstamp",                 null: false
    t.string    "sitecode",     limit: 6
    t.string    "unitinfo",     limit: 30
    t.string    "trustname",    limit: 100
    t.string    "trustcaption", limit: 30
    t.text      "siteinfohtml"
  end

  add_index "letterheadlist", ["sitecode"], name: "sitecode", unique: true, using: :btree

  create_table "letterindex", primary_key: "letterindex_id", force: true do |t|
    t.integer  "letterzid",       limit: 3
    t.string   "letterhospno",    limit: 7
    t.integer  "letteruid",       limit: 2
    t.string   "letteruser",      limit: 20
    t.datetime "createstamp"
    t.datetime "archivestamp"
    t.integer  "authorid",        limit: 2
    t.integer  "typistid",        limit: 2
    t.string   "typistinits",     limit: 6
    t.string   "lettertype",      limit: 9,   default: "clinic"
    t.date     "clinicdate"
    t.integer  "admissionid",     limit: 3
    t.date     "admdate"
    t.date     "dischdate"
    t.date     "letterdate"
    t.date     "createdate"
    t.date     "typeddate"
    t.date     "reviewdate"
    t.date     "printdate"
    t.date     "archivedate"
    t.integer  "wordcount",       limit: 2,   default: 0
    t.integer  "lettdescr_id",    limit: 2
    t.string   "lettdescr",       limit: 100
    t.string   "patlastfirst",    limit: 50
    t.string   "authorlastfirst", limit: 40
    t.string   "recipname",       limit: 100
    t.string   "modalstamp",      limit: 15
    t.text     "lettertext"
  end

  add_index "letterindex", ["admdate"], name: "admdate", using: :btree
  add_index "letterindex", ["authorid"], name: "authorid", using: :btree
  add_index "letterindex", ["lettertype"], name: "lettertype", using: :btree
  add_index "letterindex", ["letteruid"], name: "lettuid", using: :btree
  add_index "letterindex", ["letterzid"], name: "zid", using: :btree
  add_index "letterindex", ["typistid"], name: "typistid", using: :btree

  create_table "lettertemplates", primary_key: "template_id", force: true do |t|
    t.integer  "templateuid",   limit: 2
    t.string   "templatename",  limit: 100
    t.text     "templatetext"
    t.datetime "templatestamp"
  end

  add_index "lettertemplates", ["templateuid"], name: "userid", using: :btree

  create_table "lettertextdata", primary_key: "lettertext_id", force: true do |t|
    t.integer  "lettertextzid", limit: 3, default: 1,     null: false
    t.integer  "lettertextuid", limit: 2, default: 1,     null: false
    t.datetime "addstamp"
    t.datetime "modifstamp"
    t.datetime "archivestamp"
    t.datetime "deletestamp"
    t.text     "ltext"
    t.text     "lfulltext"
    t.boolean  "deleteflag",              default: false, null: false
  end

  add_index "lettertextdata", ["lettertextzid"], name: "lettzid", using: :btree

  create_table "linesepsisdata", primary_key: "linesepsisdata_id", force: true do |t|
    t.integer "linesepsiszid",      limit: 3
    t.date    "bloodculturedate"
    t.string  "cultureorg1",        limit: 50
    t.string  "cultureorg2",        limit: 50
    t.string  "cultureorg_other",   limit: 50
    t.date    "swabdate"
    t.string  "swaborg1",           limit: 50
    t.string  "swaborg2",           limit: 50
    t.string  "swaborg_other",      limit: 50
    t.string  "Oralantibioticflag", limit: 1
    t.string  "IVantibioticflag",   limit: 1
    t.string  "antibiotics"
    t.string  "linesepsisnotes"
  end

  add_index "linesepsisdata", ["linesepsiszid"], name: "linesepsiszid", using: :btree

  create_table "lupusbxdata", primary_key: "lupusbx_id", force: true do |t|
    t.timestamp "lupusbxstamp",               null: false
    t.integer   "lupusbxuid",      limit: 2
    t.string    "lupusbxuser",     limit: 20
    t.integer   "lupusbxzid",      limit: 3
    t.date      "lupusbxadddate"
    t.date      "lupusbxdate"
    t.string    "lupusbxclass",    limit: 12
    t.integer   "activityindex",   limit: 1
    t.integer   "chronicityindex", limit: 1
    t.string    "lupusbxnotes"
  end

  add_index "lupusbxdata", ["lupusbxadddate"], name: "lupusbxadddate", using: :btree
  add_index "lupusbxdata", ["lupusbxdate"], name: "lupusbxdate", using: :btree
  add_index "lupusbxdata", ["lupusbxuid"], name: "lupusbxuid", using: :btree
  add_index "lupusbxdata", ["lupusbxzid"], name: "lupusbxzid", using: :btree

  create_table "lupusdata", primary_key: "lupus_id", force: true do |t|
    t.timestamp "lupusstamp",                 null: false
    t.datetime  "lupusmodifdt"
    t.integer   "lupusuid",        limit: 2
    t.string    "lupususer",       limit: 20
    t.integer   "lupuszid",        limit: 3
    t.date      "lupusadddate"
    t.date      "lupusmodifdate"
    t.date      "lupusdxdate"
    t.date      "anatitre_dxdate"
    t.string    "anatitre_dx",     limit: 12
    t.date      "dsdna_dxdate"
    t.string    "dsdna_dx",        limit: 12
    t.string    "anticardiolipin", limit: 3
    t.string    "ena_sm",          limit: 1
    t.string    "ena_la",          limit: 1
    t.string    "ena_ro",          limit: 1
    t.string    "ena_jo1",         limit: 1
    t.string    "ena_scl70",       limit: 1
    t.string    "ena_rnp",         limit: 1
    t.date      "lastbxdate"
    t.string    "lupusclass",      limit: 12
    t.text      "lupusnotes"
  end

  add_index "lupusdata", ["lupusuid"], name: "lupusuid", using: :btree
  add_index "lupusdata", ["lupuszid"], name: "lupuszid", using: :btree

  create_table "medsdata", primary_key: "medsdata_id", force: true do |t|
    t.integer   "medzid",          limit: 3
    t.timestamp "modifstamp",                                  null: false
    t.integer   "drug_id",         limit: 2
    t.string    "drugname",        limit: 100
    t.string    "dose",            limit: 40
    t.string    "route",           limit: 12
    t.string    "freq",            limit: 30
    t.string    "drugnotes"
    t.date      "adddate"
    t.date      "termdate"
    t.string    "medmodal",        limit: 100
    t.boolean   "esdflag",                     default: false
    t.integer   "esdunitsperweek", limit: 3,   default: 0
    t.boolean   "immunosuppflag",              default: false
    t.boolean   "termflag",                    default: false
    t.integer   "adduid",          limit: 2
    t.string    "adduser",         limit: 20
    t.string    "termuser",        limit: 20
    t.string    "prescriber",      limit: 8
    t.string    "provider",        limit: 8
    t.boolean   "printflag",                   default: false
    t.date      "printdate"
    t.datetime  "printdt"
    t.integer   "printuid",        limit: 2
  end

  add_index "medsdata", ["adduid"], name: "adduid", using: :btree
  add_index "medsdata", ["drug_id"], name: "drug_id", using: :btree
  add_index "medsdata", ["medzid"], name: "zid", using: :btree
  add_index "medsdata", ["printflag"], name: "printflag", using: :btree
  add_index "medsdata", ["termflag"], name: "termflag", using: :btree

  create_table "messagedata", primary_key: "message_id", force: true do |t|
    t.timestamp "messagestamp",                           null: false
    t.integer   "message_uid",  limit: 2
    t.string    "messageuser",  limit: 20
    t.integer   "recip_uid",    limit: 2
    t.string    "recipuser",    limit: 20
    t.integer   "messagezid",   limit: 3
    t.string    "messagesubj",  limit: 100
    t.text      "messagetext"
    t.string    "readflag",     limit: 1,   default: "0"
    t.datetime  "readstamp"
    t.string    "urgentflag",   limit: 1,   default: "0"
  end

  add_index "messagedata", ["message_uid"], name: "message_uid", using: :btree
  add_index "messagedata", ["messagezid"], name: "messagezid", using: :btree
  add_index "messagedata", ["readflag"], name: "readflag", using: :btree
  add_index "messagedata", ["recip_uid"], name: "recip_uid", using: :btree

  create_table "modalcodeslist", primary_key: "modalcode_id", force: true do |t|
    t.string "modalcode",   limit: 20
    t.string "modality",    limit: 100
    t.string "rrmodalcode", limit: 2
  end

  add_index "modalcodeslist", ["modalcode"], name: "modalcode", unique: true, using: :btree

  create_table "modaldata", primary_key: "modal_id", force: true do |t|
    t.integer  "modalzid",      limit: 3,   default: 0, null: false
    t.string   "modalcode",     limit: 20
    t.string   "modalsitecode", limit: 10
    t.datetime "modalstamp"
    t.date     "modaldate"
    t.string   "modalnotes",    limit: 100
    t.string   "modaluser",     limit: 20
    t.string   "rrmodalcode",   limit: 2
    t.date     "modaltermdate"
  end

  add_index "modaldata", ["modalcode"], name: "modalcode", using: :btree
  add_index "modaldata", ["modaldate"], name: "modaldate", using: :btree
  add_index "modaldata", ["modalzid"], name: "modalzid", using: :btree
  add_index "modaldata", ["rrmodalcode"], name: "rrmodalcode", using: :btree

  create_table "mrsadata", primary_key: "mrsa_id", force: true do |t|
    t.timestamp "swabstamp",              null: false
    t.integer   "mrsazid",     limit: 3
    t.integer   "swabuid",     limit: 2
    t.string    "swabuser",    limit: 20
    t.date      "swabadddate"
    t.date      "swabdate"
    t.string    "swabsite",    limit: 60
    t.datetime  "resultstamp"
    t.string    "resultuser",  limit: 20
    t.date      "resultdate"
    t.string    "swabresult",  limit: 3
  end

  add_index "mrsadata", ["mrsazid"], name: "mrsazid", using: :btree
  add_index "mrsadata", ["swabdate"], name: "swabdate", using: :btree
  add_index "mrsadata", ["swabresult"], name: "swabresult", using: :btree

  create_table "optionlists", primary_key: "option_id", force: true do |t|
    t.timestamp "liststamp"
    t.string    "listname",      limit: 30
    t.text      "listhtml"
    t.datetime  "listmodifdt"
    t.string    "listmodifuser", limit: 20
  end

  add_index "optionlists", ["listname"], name: "listname", using: :btree

  create_table "pageviews", id: false, force: true do |t|
    t.integer  "page_uid",   limit: 2
    t.string   "page_uri",   limit: 100
    t.datetime "pagestamp"
    t.integer  "pagezid",    limit: 3
    t.integer  "session_id", limit: 3
    t.string   "user",       limit: 30
    t.string   "page_title", limit: 150
  end

  create_table "patientdata", primary_key: "patzid", force: true do |t|
    t.datetime "modifstamp"
    t.datetime "addstamp"
    t.integer  "adduid",                 limit: 2
    t.string   "adduser",                limit: 20
    t.string   "hospno1",                limit: 8
    t.string   "hospno2",                limit: 20
    t.string   "hospno3",                limit: 20
    t.string   "hospno4",                limit: 12
    t.string   "hospno5",                limit: 12
    t.string   "hosprefno",              limit: 20
    t.string   "privpatno",              limit: 20
    t.string   "nhsno",                  limit: 10
    t.string   "title",                  limit: 4
    t.string   "lastname",               limit: 30
    t.string   "firstnames",             limit: 30
    t.string   "suffix",                 limit: 6
    t.string   "sex",                    limit: 8
    t.date     "birthdate"
    t.date     "deathdate"
    t.integer  "age",                    limit: 1
    t.string   "modalcode",              limit: 20,       default: "unknown"
    t.string   "modalsite",              limit: 20
    t.string   "maritstatus",            limit: 16
    t.string   "ethnicity",              limit: 50
    t.string   "religion",               limit: 30
    t.string   "language",               limit: 30
    t.string   "interpreter",            limit: 30
    t.string   "specialneeds"
    t.string   "addr1",                  limit: 90
    t.string   "addr2",                  limit: 90
    t.string   "addr3",                  limit: 90
    t.string   "addr4",                  limit: 50
    t.string   "postcode",               limit: 12
    t.string   "tel1",                   limit: 100
    t.string   "tel2",                   limit: 100
    t.string   "fax",                    limit: 30
    t.string   "mobile",                 limit: 30
    t.string   "email",                  limit: 50
    t.string   "tempaddr"
    t.string   "nok_name",               limit: 90
    t.string   "nok_addr1",              limit: 90
    t.string   "nok_addr2",              limit: 90
    t.string   "nok_addr3",              limit: 90
    t.string   "nok_addr4",              limit: 50
    t.string   "nok_postcode",           limit: 12
    t.string   "nok_tels",               limit: 90
    t.string   "nok_email",              limit: 50
    t.string   "nok_notes"
    t.integer  "gp_id"
    t.string   "gp_natcode",             limit: 9,        default: "NULL"
    t.string   "gp_name",                limit: 100
    t.string   "gp_addr1",               limit: 100
    t.string   "gp_addr2",               limit: 100
    t.string   "gp_addr3",               limit: 100
    t.string   "gp_addr4",               limit: 100
    t.string   "gp_postcode",            limit: 12
    t.string   "gp_tel",                 limit: 30
    t.string   "gp_fax",                 limit: 30
    t.string   "gp_email",               limit: 50
    t.string   "healthauthcode",         limit: 20
    t.string   "referrer"
    t.date     "refer_date"
    t.string   "refer_type",             limit: 60
    t.string   "refer_notes"
    t.string   "pctcode",                limit: 3
    t.string   "pctname",                limit: 50
    t.date     "transferdate"
    t.string   "pharmacist",             limit: 100
    t.string   "pharmacist_addr"
    t.string   "pharmacist_phone",       limit: 100
    t.string   "districtnurse",          limit: 100
    t.string   "districtnurse_addr"
    t.string   "districtnurse_phone",    limit: 100
    t.text     "adminnotes"
    t.text     "defaultccs"
    t.text     "hl7pidblock",            limit: 16777215
    t.text     "hl7pd1block",            limit: 16777215
    t.string   "patsite",                limit: 4
    t.string   "advancedirflag",         limit: 1
    t.date     "advancedirdate"
    t.text     "advancedirsumm",         limit: 255
    t.text     "advancedirlpatext",                                           null: false
    t.string   "advancedirtype",         limit: 100
    t.string   "advancedirstaff",        limit: 50
    t.string   "lastingpowerflag",       limit: 1
    t.date     "lastingpowerdate"
    t.text     "lastingpowerattdata",    limit: 255
    t.string   "lastingpowertype",       limit: 100
    t.string   "lastingpowerstaff",      limit: 50
    t.string   "ccflag",                 limit: 1,        default: "Y"
    t.date     "ccflagdate"
    t.string   "renalregoptout",         limit: 1,        default: "Y",       null: false
    t.date     "renalregdate"
    t.string   "renalregstaff",          limit: 30
    t.boolean  "rregflag",                                default: false
    t.string   "rregno",                 limit: 24
    t.boolean  "photoflag",                               default: false
    t.boolean  "esdflag",                                 default: false
    t.boolean  "esrfflag",                                default: false
    t.boolean  "immunosuppflag",                          default: false
    t.string   "immunosuppdrugdelivery", limit: 20,       default: "GP"
    t.boolean  "hdflag",                                  default: false
    t.boolean  "pdflag",                                  default: false
    t.datetime "lasteventstamp"
    t.date     "lasteventdate"
    t.string   "lasteventuser",          limit: 20
    t.text     "sticky",                 limit: 255,                          null: false
    t.text     "advancedirtext"
    t.text     "advancedirlocation",     limit: 255
    t.text     "lastingpowertext1"
    t.string   "lastingpowertype1",      limit: 16
    t.string   "lastingpowertype2",      limit: 16
    t.text     "lastingpowertext2"
    t.text     "alert",                  limit: 255
    t.string   "transportflag",          limit: 1
    t.date     "transportdate"
    t.string   "transporttype",          limit: 60
    t.string   "transportdecider",       limit: 30
    t.string   "rpvstatus",              limit: 12
    t.string   "rpvuser",                limit: 20
    t.datetime "rpvmodifstamp"
    t.datetime "pimsupdatestamp"
  end

  add_index "patientdata", ["ethnicity"], name: "ethnicity", using: :btree
  add_index "patientdata", ["firstnames"], name: "firstnames", using: :btree
  add_index "patientdata", ["gp_natcode"], name: "gp_natcode", using: :btree
  add_index "patientdata", ["hospno1"], name: "hospno1", using: :btree
  add_index "patientdata", ["hospno2"], name: "hospno2", using: :btree
  add_index "patientdata", ["hospno3"], name: "hospno3", using: :btree
  add_index "patientdata", ["hospno4"], name: "hospno4", using: :btree
  add_index "patientdata", ["hospno5"], name: "hospno5", using: :btree
  add_index "patientdata", ["lastname"], name: "lastname", using: :btree
  add_index "patientdata", ["modalcode"], name: "modalcode", using: :btree
  add_index "patientdata", ["modifstamp"], name: "modifstamp", using: :btree
  add_index "patientdata", ["nhsno"], name: "nhsno", using: :btree
  add_index "patientdata", ["rregflag"], name: "rregflag", using: :btree

>>>>>>> aa72a96... migrated columns for encounter_events
  create_table "patients", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nhs_number"
    t.string   "local_patient_id"
    t.string   "surname"
    t.string   "forename"
    t.date     "dob"
    t.boolean  "paediatric_patient_indicator"
    t.string   "sex"
    t.string   "ethnic_category"
    t.integer  "current_address_id"
    t.integer  "address_at_diagnosis_id"
    t.string   "gp_practice_code"
    t.string   "pct_org_code"
    t.string   "hosp_centre_code"
    t.string   "primary_esrf_centre"
  end

end
