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

ActiveRecord::Schema.define(version: 20141020171819) do

  create_table "accessclinics", primary_key: "accessclinic_id", force: true do |t|
    t.integer  "accessclinzid",  limit: 3
    t.datetime "addstamp"
    t.string   "accessclinuser", limit: 30
    t.date     "accessclindate"
    t.string   "surgeon",        limit: 30
    t.string   "decision"
    t.string   "ixrequests"
    t.string   "anaesth",        limit: 2
    t.string   "priority",       limit: 7
  end

  add_index "accessclinics", ["accessclinzid"], name: "accessclinrid", using: :btree

  create_table "accessfxndata", primary_key: "accessfxndata_id", force: true do |t|
    t.integer  "accessfxnzid",         limit: 3
    t.string   "accessfxnuser",        limit: 30
    t.datetime "addstamp"
    t.string   "modalstamp",           limit: 30
    t.date     "assessmentdate"
    t.string   "accesstype",           limit: 100
    t.string   "assessmentmethod",     limit: 100
    t.string   "flow_feedartery",      limit: 30
    t.integer  "artstenosisflag"
    t.string   "artstenosistext"
    t.boolean  "venstenosisflag"
    t.string   "venstenosistext"
    t.string   "rx_decision"
    t.date     "proceduredate"
    t.string   "proced_type",          limit: 100
    t.string   "proced_outcome"
    t.boolean  "residualstenosisflag"
    t.string   "surveillance",         limit: 50
    t.string   "assessmentoutcome",    limit: 5
  end

  add_index "accessfxndata", ["accessfxnzid"], name: "accessfxnzid", using: :btree

  create_table "accessprocdata", primary_key: "accessprocdata_id", force: true do |t|
    t.integer  "accessproczid",  limit: 3
    t.string   "proced"
    t.string   "operator",       limit: 30
    t.boolean  "firstflag"
    t.string   "outcome"
    t.date     "firstused_date"
    t.date     "failuredate"
    t.date     "proceduredate"
    t.datetime "addstamp"
    t.string   "accessprocuser", limit: 30
    t.string   "cathetermake",   limit: 30
    t.string   "catheterlotno",  limit: 15
    t.datetime "modifstamp"
  end

  add_index "accessprocdata", ["accessproczid"], name: "accessprocrid", using: :btree

  create_table "admissiondata", primary_key: "admission_id", force: true do |t|
    t.integer  "admzid",          limit: 3
    t.datetime "admmodifstamp"
    t.datetime "admaddstamp"
    t.boolean  "admittedflag",               default: true
    t.string   "admhospno1",      limit: 7
    t.string   "patlastfirst",    limit: 50
    t.string   "admmodal",        limit: 20
    t.date     "admdate"
    t.datetime "admdt"
    t.string   "admward",         limit: 20
    t.string   "consultant",      limit: 20
    t.string   "admtype",         limit: 20
    t.string   "reason",          limit: 60
    t.string   "transferward",    limit: 20
    t.date     "transferdate"
    t.date     "dischdate"
    t.string   "dischdest",       limit: 30
    t.boolean  "deathflag"
    t.string   "admstatus",       limit: 10, default: "Admitted", null: false
    t.integer  "admdays",         limit: 2
    t.string   "currward",        limit: 20
    t.string   "outward",         limit: 20
    t.string   "category",        limit: 20
    t.string   "dischsummstatus", limit: 40, default: "create"
    t.date     "dischsummdate"
    t.integer  "hl7msh_id"
    t.string   "servicecode",     limit: 10
    t.string   "eventcode",       limit: 3
    t.boolean  "dischsummflag",              default: false,      null: false
    t.string   "pid_date",        limit: 17
  end

  add_index "admissiondata", ["admdate"], name: "admdate", using: :btree
  add_index "admissiondata", ["admhospno1"], name: "admhospno1", using: :btree
  add_index "admissiondata", ["admittedflag"], name: "admittedflag", using: :btree
  add_index "admissiondata", ["admward"], name: "admward", using: :btree
  add_index "admissiondata", ["admzid"], name: "admrid", using: :btree
  add_index "admissiondata", ["dischsummstatus"], name: "dischsummstatus", using: :btree
  add_index "admissiondata", ["hl7msh_id"], name: "hl7admission_id", using: :btree
  add_index "admissiondata", ["patlastfirst"], name: "patlastfirst", using: :btree

  create_table "akidata", primary_key: "aki_id", force: true do |t|
    t.timestamp "akistamp",                                                 null: false
    t.datetime  "akimodifdt"
    t.integer   "akiuid",               limit: 2
    t.string    "akiuser",              limit: 20
    t.integer   "akizid",               limit: 3
    t.integer   "consultid",            limit: 3
    t.date      "akiadddate"
    t.date      "akimodifdate"
    t.date      "episodedate"
    t.string    "episodestatus",        limit: 30
    t.date      "referraldate"
    t.string    "admissionmethod",      limit: 60
    t.boolean   "elderlyscore"
    t.boolean   "existingckdscore"
    t.string    "ckdstatus",            limit: 12
    t.boolean   "cardiacfailurescore"
    t.boolean   "diabetesscore"
    t.boolean   "liverdiseasescore"
    t.boolean   "vasculardiseasescore"
    t.boolean   "nephrotoxicmedscore"
    t.boolean   "akiriskscore"
    t.integer   "cre_baseline",         limit: 2
    t.integer   "cre_peak",             limit: 2
    t.decimal   "egfr_baseline",                    precision: 5, scale: 1
    t.string    "urineoutput",          limit: 30
    t.string    "urineblood",           limit: 6
    t.string    "urineprotein",         limit: 6
    t.boolean   "akinstage"
    t.string    "stopdiagnosis",        limit: 60
    t.string    "stopsubtype",          limit: 60
    t.string    "stopsubtypenotes"
    t.string    "akicode",              limit: 1
    t.string    "ituflag",              limit: 1
    t.date      "itudate"
    t.string    "renalunitflag",        limit: 1
    t.date      "renalunitdate"
    t.string    "itustepdownflag",      limit: 1
    t.string    "rrtflag",              limit: 1
    t.string    "rrttype",              limit: 12
    t.string    "rrtduration",          limit: 12
    t.string    "rrtnotes",             limit: 100
    t.text      "mgtnotes"
    t.string    "akioutcome"
    t.string    "ussflag",              limit: 1
    t.date      "ussdate"
    t.text      "ussnotes"
    t.string    "biopsyflag",           limit: 1
    t.date      "biopsydate"
    t.text      "biopsynotes"
    t.text      "otherix"
    t.text      "akinotes"
  end

  add_index "akidata", ["akiuid"], name: "akiuid", using: :btree
  add_index "akidata", ["akizid"], name: "akizid", using: :btree
  add_index "akidata", ["consultid"], name: "consultid", using: :btree
  add_index "akidata", ["episodedate"], name: "episodedate", using: :btree

  create_table "apdrxdata", primary_key: "apdrx_id", force: true do |t|
    t.integer  "apdrxzid",       limit: 3
    t.datetime "addstamp"
    t.string   "adduser",        limit: 30
    t.integer  "adduid",         limit: 2
    t.date     "adddate"
    t.string   "therapytype",    limit: 50
    t.integer  "totalvol",       limit: 2
    t.string   "dextrose",       limit: 50
    t.string   "therapytime",    limit: 12
    t.integer  "fillvolume",     limit: 2
    t.string   "lastfill",       limit: 12
    t.string   "extraneal",      limit: 3
    t.integer  "no_cycles",      limit: 1
    t.string   "avgdwelltime",   limit: 12
    t.integer  "initdrainalarm", limit: 2
    t.string   "signature",      limit: 30
    t.string   "calcium",        limit: 3
    t.string   "ph",             limit: 12
    t.string   "optichoice",     limit: 24
  end

  add_index "apdrxdata", ["apdrxzid"], name: "apdrxzid", using: :btree

  create_table "arc_eq5ddata", primary_key: "eq5d_id", force: true do |t|
    t.timestamp "eq5dstamp",                        null: false
    t.integer   "eq5duid",               limit: 2
    t.string    "eq5duser",              limit: 20
    t.integer   "eq5dzid",               limit: 3
    t.date      "eq5dadddate"
    t.date      "eq5ddate"
    t.string    "mobility",              limit: 24
    t.string    "selfcare",              limit: 24
    t.string    "activities",            limit: 24
    t.string    "pain_discomfort",       limit: 24
    t.string    "anxiety_depress",       limit: 24
    t.integer   "healthstate",           limit: 1
    t.string    "seriousillness_self",   limit: 1
    t.string    "seriousillness_family", limit: 1
    t.string    "seriousillness_others", limit: 1
    t.integer   "currage",               limit: 1
    t.string    "gender",                limit: 1
    t.string    "smoking",               limit: 9
    t.string    "healthsocialworker",    limit: 1
    t.string    "healthsocialworktype",  limit: 70
    t.string    "mainactivity",          limit: 40
    t.string    "mainactivity_other",    limit: 70
    t.string    "continuededuc",         limit: 1
    t.string    "degree_qualif",         limit: 1
    t.string    "postcode",              limit: 12
  end

  add_index "arc_eq5ddata", ["eq5dadddate"], name: "eq5dadddate", using: :btree
  add_index "arc_eq5ddata", ["eq5duid"], name: "eq5duid", using: :btree
  add_index "arc_eq5ddata", ["eq5dzid"], name: "eq5dzid", using: :btree

  create_table "arc_possdata2", primary_key: "poss_id", force: true do |t|
    t.timestamp "possstamp",                      null: false
    t.integer   "possuid",             limit: 2
    t.string    "possuser",            limit: 20
    t.integer   "posszid",             limit: 3
    t.date      "possadddate"
    t.date      "possdate"
    t.boolean   "pain"
    t.boolean   "shortness_of_breath"
    t.boolean   "weakness"
    t.boolean   "nausea"
    t.boolean   "vomiting"
    t.boolean   "poor_appetite"
    t.boolean   "constipation"
    t.boolean   "mouth_problems"
    t.boolean   "drowsiness"
    t.boolean   "poor_mobility"
    t.boolean   "itching"
    t.boolean   "insomnia"
    t.boolean   "restless_legs"
    t.boolean   "anxiety"
    t.boolean   "depression"
    t.boolean   "skinchanges"
    t.boolean   "diarrhoea"
    t.string    "othersymptom1",       limit: 50
    t.string    "othersymptom2",       limit: 50
    t.string    "othersymptom3",       limit: 50
    t.boolean   "othersymptom1score"
    t.boolean   "othersymptom2score"
    t.boolean   "othersymptom3score"
    t.string    "affected_most",       limit: 50
    t.string    "improved_most",       limit: 50
    t.integer   "totalposs_score",     limit: 2
  end

  add_index "arc_possdata2", ["possadddate"], name: "possadddate", using: :btree
  add_index "arc_possdata2", ["possdate"], name: "possdate", using: :btree
  add_index "arc_possdata2", ["possuid"], name: "possuid", using: :btree
  add_index "arc_possdata2", ["posszid"], name: "posszid", using: :btree

  create_table "arcdata", primary_key: "arc_id", force: true do |t|
    t.timestamp "arcstamp",                          null: false
    t.datetime  "arcmodifstamp"
    t.integer   "arcuid",                limit: 2
    t.string    "arcuser",               limit: 20
    t.integer   "arczid",                limit: 3
    t.date      "arcadddate"
    t.date      "arcmodifdate"
    t.string    "whereseen",             limit: 30
    t.string    "surpriseflag",          limit: 1
    t.date      "surprisedate"
    t.string    "surveyconsentflag",     limit: 1
    t.string    "ihdflag",               limit: 1
    t.string    "pvdflag",               limit: 1
    t.string    "dementiaflag",          limit: 1
    t.string    "lowalbuminflag",        limit: 1
    t.string    "weightlossflag",        limit: 1
    t.string    "myeloma_cancerflag",    limit: 1
    t.integer   "karnofskyscore",        limit: 1
    t.text      "symptoms"
    t.text      "patientfamilylog"
    t.text      "healthproviderlog"
    t.text      "arcplanninglog"
    t.text      "placeofcareprefs"
    t.string    "counsellorrefflag",     limit: 1
    t.date      "counsellorrefdate"
    t.text      "counsellorcomments"
    t.string    "socialworkerrefflag",   limit: 1
    t.date      "socialworkerrefdate"
    t.text      "socialworkercomments"
    t.string    "hospicerefflag",        limit: 1
    t.date      "hospicerefdate"
    t.string    "hospicename",           limit: 70
    t.text      "endoflifeplans"
    t.date      "deathdate"
    t.string    "deathplace",            limit: 200
    t.string    "deathcause"
    t.text      "bereavementnotes"
    t.string    "questionnairesentflag", limit: 1
    t.date      "questionnairedate"
    t.text      "archistory"
    t.string    "arcdiagnosis",          limit: 200
    t.string    "goldregisterflag",      limit: 1
    t.string    "golddiscussedflag",     limit: 1
    t.string    "goldacpflag",           limit: 1
    t.string    "goldecommregisterflag", limit: 1
  end

  add_index "arcdata", ["arcuid"], name: "arcuid", using: :btree
  add_index "arcdata", ["arczid"], name: "arczid", using: :btree

  create_table "bookmarkdata", primary_key: "mark_id", force: true do |t|
    t.datetime "markstamp"
    t.integer  "markzid",      limit: 3
    t.integer  "markuid",      limit: 2
    t.string   "marknotes"
    t.string   "marklist",     limit: 30
    t.string   "markpriority", limit: 6,  default: "Normal"
  end

  add_index "bookmarkdata", ["markuid"], name: "markuid", using: :btree
  add_index "bookmarkdata", ["markzid"], name: "markzid", using: :btree

  create_table "bpwtdata", primary_key: "bpwt_id", force: true do |t|
    t.integer  "bpwtzid",     limit: 3
    t.integer  "bpwtuid",     limit: 2
    t.datetime "bpwtstamp"
    t.string   "bpwtmodal",   limit: 50
    t.date     "bpwtdate"
    t.integer  "bpsyst",      limit: 2
    t.integer  "bpdiast",     limit: 2
    t.decimal  "weight",                 precision: 5, scale: 2
    t.decimal  "height",                 precision: 3, scale: 2
    t.string   "bpwttype",    limit: 60
    t.decimal  "BMI",                    precision: 3, scale: 1
    t.string   "urine_prot",  limit: 6
    t.string   "urine_blood", limit: 6
    t.date     "urinedate"
    t.integer  "lett_id"
  end

  add_index "bpwtdata", ["bpwtdate"], name: "bpwtdate", using: :btree
  add_index "bpwtdata", ["bpwtuid"], name: "bpwtuid", using: :btree
  add_index "bpwtdata", ["bpwtzid"], name: "bpwtzid", using: :btree
  add_index "bpwtdata", ["lett_id"], name: "lett_id", using: :btree

  create_table "capdrxdata", primary_key: "capdrx_id", force: true do |t|
    t.integer  "capdrxzid",   limit: 3
    t.datetime "addstamp"
    t.string   "adduser",     limit: 30
    t.integer  "adduid",      limit: 2
    t.date     "adddate"
    t.boolean  "no_exchange"
    t.integer  "volume",      limit: 3
    t.string   "dextrose",    limit: 50
    t.string   "calcium",     limit: 12
    t.string   "system",      limit: 8
    t.string   "extraneal",   limit: 12
    t.string   "ph",          limit: 20
    t.string   "signature",   limit: 30
  end

  add_index "capdrxdata", ["capdrxzid"], name: "capdrxzid", using: :btree

  create_table "capdworkups", primary_key: "workup_id", force: true do |t|
    t.integer   "workupzid",         limit: 3
    t.timestamp "workupmodifstamp",              null: false
    t.datetime  "workupaddstamp"
    t.string    "workupuser",        limit: 20
    t.date      "workupdate"
    t.string    "workupnurse",       limit: 40
    t.date      "homevisitdate"
    t.string    "housingtype",       limit: 30
    t.integer   "no_rooms",          limit: 1
    t.string    "exchangearea"
    t.string    "handwashing"
    t.string    "fluidstorage"
    t.string    "bagwarming"
    t.string    "freqdeliveries"
    t.string    "rehousingflag",     limit: 1
    t.text      "rehousingreasons"
    t.string    "socialworkerflag",  limit: 1
    t.date      "nurseassessdate"
    t.string    "seenvideo",         limit: 1
    t.string    "ableopenbag",       limit: 1
    t.string    "ableliftbag",       limit: 1
    t.string    "eyesight"
    t.string    "hearing"
    t.string    "dexterity"
    t.string    "motivation"
    t.string    "language"
    t.text      "notes"
    t.string    "suitableflag",      limit: 1
    t.string    "systemchoice",      limit: 100
    t.string    "insertdiscussflag", limit: 1
    t.string    "methodchosen"
    t.string    "accessclinrefflag", limit: 1
    t.date      "accessclinrefdate"
    t.string    "abdoassessor",      limit: 50
    t.text      "addedcomments"
    t.integer   "no_occupants",      limit: 1
    t.text      "occupantnotes"
    t.string    "boweldisflag",      limit: 1
    t.text      "boweldisnotes"
    t.string    "homevisitflag",     limit: 1
  end

  add_index "capdworkups", ["workupzid"], name: "workupzid", using: :btree

  create_table "clinstudylist", primary_key: "study_id", force: true do |t|
    t.string    "studycode",   limit: 25
    t.string    "studyname",   limit: 100
    t.string    "studynotes"
    t.timestamp "studystamp",              null: false
    t.string    "studyleader", limit: 30
    t.date      "studydate"
  end

  create_table "clinstudypatdata", primary_key: "clinstudypat_id", force: true do |t|
    t.integer  "clinstudyzid",      limit: 3
    t.integer  "studyid",           limit: 1
    t.datetime "clinstudypatstamp"
    t.string   "patadduser",        limit: 20
    t.date     "patadddate"
    t.date     "termdate"
  end

  add_index "clinstudypatdata", ["clinstudyzid"], name: "clinstudyzid", using: :btree
  add_index "clinstudypatdata", ["studyid"], name: "studyid", using: :btree

  create_table "consultants", primary_key: "cons_id", force: true do |t|
    t.string "conscode",     limit: 12
    t.string "conslast",     limit: 20
    t.string "consfirst",    limit: 30
    t.string "consfullname", limit: 50
  end

  create_table "consultdata", primary_key: "consult_id", force: true do |t|
    t.timestamp "consultstamp",                                null: false
    t.datetime  "consultmodifstamp"
    t.integer   "consultuid",        limit: 2
    t.string    "consultuser",       limit: 20
    t.string    "consultstaffname",  limit: 50
    t.integer   "consultzid",        limit: 3
    t.string    "consultmodal",      limit: 20
    t.date      "consultstartdate"
    t.date      "consultenddate"
    t.string    "consultward",       limit: 50
    t.string    "consulttype",       limit: 50
    t.text      "consultdescr",      limit: 255
    t.text      "consulttext"
    t.string    "activeflag",        limit: 1,   default: "Y"
    t.string    "akiriskflag",       limit: 1
    t.string    "consultsite",       limit: 8
    t.string    "othersite",         limit: 60
    t.string    "contactbleep",      limit: 20
    t.string    "sitehospno",        limit: 20
    t.string    "transferpriority",  limit: 12
    t.date      "decisiondate"
    t.date      "transferdate"
  end

  add_index "consultdata", ["consultenddate"], name: "consultenddate", using: :btree
  add_index "consultdata", ["consultsite"], name: "consultsite", using: :btree
  add_index "consultdata", ["consultstartdate"], name: "consultstartdate", using: :btree
  add_index "consultdata", ["consultuid"], name: "consultuid", using: :btree
  add_index "consultdata", ["consultzid"], name: "consultzid", using: :btree

  create_table "currentclindata", primary_key: "currentclinzid", force: true do |t|
    t.datetime "currentadddate"
    t.integer  "BPsyst",         limit: 2
    t.integer  "BPdiast",        limit: 2
    t.date     "BPdate"
    t.decimal  "Weight",                   precision: 4, scale: 1
    t.date     "Weightdate"
    t.decimal  "Height",                   precision: 3, scale: 2
    t.date     "Heightdate"
    t.decimal  "BMI",                      precision: 3, scale: 1
    t.datetime "currentstamp"
  end

  create_table "downloads", primary_key: "download_id", force: true do |t|
    t.string "filetitle", limit: 100
    t.string "filedescr"
    t.string "filename",  limit: 100
    t.date   "addstamp"
  end

  create_table "druglist", primary_key: "drug_id", force: true do |t|
    t.string   "drugname",       limit: 60
    t.boolean  "esdflag",                   default: false
    t.boolean  "immunosuppflag",            default: false
    t.string   "user",           limit: 30
    t.datetime "addstamp"
  end

  add_index "druglist", ["drugname"], name: "drugname", using: :btree
  add_index "druglist", ["esdflag"], name: "esdflag", using: :btree
  add_index "druglist", ["immunosuppflag"], name: "immunosuppflag", using: :btree

  create_table "edtadeathcodes", primary_key: "edtacode", force: true do |t|
    t.string "edtacause"
  end

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

  create_table "patients", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nhs_number"
    t.string   "local_patient_id"
    t.string   "surname"
    t.string   "forename"
    t.date     "dob"
    t.string   "paediatric_patient_indicator"
    t.string   "sex"
    t.string   "ethnic_category"
  end

  create_table "patstats", primary_key: "statzid", force: true do |t|
    t.timestamp "statstamp",                        null: false
    t.string    "statpid",    limit: 7
    t.integer   "admissions", limit: 2, default: 0, null: false
    t.integer   "encounters", limit: 2, default: 0, null: false
    t.integer   "pathix",     limit: 2, default: 0, null: false
    t.integer   "ixdata",     limit: 2, default: 0, null: false
    t.integer   "letters",    limit: 2, default: 0, null: false
    t.integer   "problems",   limit: 1, default: 0, null: false
    t.integer   "meds",       limit: 1, default: 0, null: false
    t.integer   "modals",     limit: 1, default: 0, null: false
    t.integer   "bpwts",      limit: 2, default: 0, null: false
    t.integer   "hdsess",     limit: 2, default: 0, null: false
    t.integer   "ops",        limit: 2, default: 0, null: false
    t.integer   "events",     limit: 2, default: 0, null: false
  end

  add_index "patstats", ["statpid"], name: "statpid", using: :btree

  create_table "pdpatdata", id: false, force: true do |t|
    t.integer  "pdpatzid",             limit: 3,  null: false
    t.datetime "pdaddstamp"
    t.datetime "pdmodifstamp"
    t.string   "pdstatus",             limit: 20
    t.date     "pdstartdate"
    t.string   "totaldailyfluidvol",   limit: 12
    t.string   "weeklyvol",            limit: 12
    t.string   "bagsize",              limit: 20
    t.string   "fluidconc",            limit: 40
    t.date     "linechangedate"
    t.string   "pdsystem",             limit: 30
    t.string   "bagconc",              limit: 20
    t.string   "adeq_KTVweekly",       limit: 20
    t.string   "adeq_CrClweekly",      limit: 20
    t.date     "PETdate"
    t.string   "PETtransporterstatus", limit: 30
    t.string   "PETrecommregime",      limit: 50
    t.boolean  "gentamycinflag"
    t.date     "gentstartdate"
  end

  add_index "pdpatdata", ["pdpatzid"], name: "pdpatzid", unique: true, using: :btree

  create_table "peritonitisdata", primary_key: "peritonitisdata_id", force: true do |t|
    t.integer  "peritzid",         limit: 3
    t.date     "rxstartdate"
    t.date     "rxenddate"
    t.string   "organism1",        limit: 50
    t.string   "organism2",        limit: 50
    t.integer  "WCcount"
    t.string   "IPantibioticflag", limit: 6
    t.string   "IVantibioticflag", limit: 6
    t.string   "peritnotes"
    t.datetime "addstamp"
    t.datetime "modifstamp"
  end

  add_index "peritonitisdata", ["peritzid"], name: "peritzid", using: :btree

  create_table "petadeqdata", primary_key: "petadeq_id", force: true do |t|
    t.integer  "petadeqzid",         limit: 3
    t.datetime "addstamp"
    t.string   "adduser",            limit: 30
    t.integer  "adduid",             limit: 2
    t.date     "adddate"
    t.string   "transporterstatus",  limit: 12
    t.decimal  "ktv",                           precision: 4, scale: 2
    t.decimal  "cre_clear",                     precision: 5, scale: 2
    t.string   "fluidremoval_24hrs", limit: 12
    t.string   "urinevolume_24hrs",  limit: 12
    t.string   "regimechange",       limit: 1
    t.date     "petdate"
    t.date     "adeqdate"
  end

  add_index "petadeqdata", ["petadeqzid"], name: "petadeqzid", using: :btree

  create_table "practiceemaillist", primary_key: "email_id", force: true do |t|
    t.timestamp "addstamp",                  null: false
    t.string    "practicecode",  limit: 12
    t.string    "practicename",  limit: 100
    t.string    "practiceemail", limit: 100
  end

  add_index "practiceemaillist", ["practicecode"], name: "practicecode", unique: true, using: :btree

  create_table "problemdata", primary_key: "problem_id", force: true do |t|
    t.integer  "probzid",   limit: 3
    t.datetime "probstamp"
    t.integer  "probuid",   limit: 1
    t.string   "probuser",  limit: 20
    t.string   "problem"
    t.text     "probnotes"
    t.string   "probcode",  limit: 100
    t.date     "probdate"
  end

  add_index "problemdata", ["probzid"], name: "zid", using: :btree

  create_table "psychsoc_encounterdata", primary_key: "encounter_id", force: true do |t|
    t.integer   "enczid",      limit: 3
    t.timestamp "encstamp",                null: false
    t.string    "encuser",     limit: 20
    t.string    "encmodal",    limit: 20
    t.date      "encdate"
    t.string    "enctime",     limit: 20
    t.string    "enctype",     limit: 18
    t.text      "encdescr",    limit: 255
    t.text      "enctext"
    t.string    "staffname",   limit: 50
    t.boolean   "publishflag"
  end

  add_index "psychsoc_encounterdata", ["enczid"], name: "enczid", using: :btree

  create_table "renalbxdata", primary_key: "renalbxdata_id", force: true do |t|
    t.date      "renalbxdate"
    t.integer   "renalbxzid",    limit: 3
    t.string    "renalbxresult"
    t.timestamp "renalbxstamp",             null: false
    t.string    "renalbxuser",   limit: 20
  end

  add_index "renalbxdata", ["renalbxzid"], name: "renalbxzid", using: :btree

  create_table "renaldata", id: false, force: true do |t|
    t.integer  "renalzid",               limit: 3,                           default: 0,         null: false
    t.datetime "renalmodifstamp"
    t.text     "clinAlcoholHx",          limit: 255
    t.text     "clinAllergies",          limit: 255
    t.text     "clinCormorbidity",       limit: 255
    t.text     "clinFamilyHx",           limit: 255
    t.text     "clinHLAType",            limit: 255
    t.text     "clinMRSAstatus",         limit: 255
    t.date     "clinMRSAtestDate"
    t.text     "clinSmokingHx",          limit: 255
    t.text     "clinSocialHx",           limit: 255
    t.integer  "deathCauseEDTA1",        limit: 1
    t.integer  "deathCauseEDTA2",        limit: 1
    t.text     "deathCauseText1",        limit: 255
    t.text     "deathCauseText2",        limit: 255
    t.text     "deathnotes"
    t.string   "accessCurrent",          limit: 40
    t.date     "accessCurrDate"
    t.string   "accessPlan",             limit: 60
    t.string   "accessPlanner",          limit: 50
    t.date     "accessPlandate"
    t.date     "accessLastAssessdate"
    t.string   "accessRxDecision",       limit: 100
    t.string   "accessSurveillance",     limit: 50
    t.string   "accessAssessOutcome",    limit: 5
    t.string   "ixECGFlag",              limit: 1
    t.string   "ixEchoFlag",             limit: 1
    t.string   "ixExerciseECGFlag",      limit: 50
    t.string   "lowAccessClinic"
    t.date     "lowFirstseendate"
    t.string   "lowDialPlan"
    t.date     "lowDialPlandate"
    t.date     "lowPredictedESRFdate"
    t.integer  "lowReferralCRE",         limit: 2
    t.string   "lowReferredBy"
    t.string   "lowEducationStatus",     limit: 8
    t.date     "txWaitListEntryDate"
    t.date     "txWaitListModifDate"
    t.text     "txWaitListNotes"
    t.string   "txWaitListStatus",       limit: 60
    t.string   "TxNHBconsent",           limit: 7,                           default: "Unknown"
    t.date     "TxNHBconsentdate"
    t.string   "TxNHBconsentstaff",      limit: 20
    t.integer  "txAbsHighest",           limit: 2
    t.date     "txAbsHighestDate"
    t.integer  "txAbsLatest",            limit: 2
    t.date     "txAbsLatestDate"
    t.string   "txBloodGroup",           limit: 5
    t.string   "txHLAType"
    t.date     "txHLATypeDate"
    t.integer  "txNoGrafts",             limit: 1
    t.string   "txSensStatus",           limit: 30
    t.string   "txTransplType",          limit: 50
    t.string   "txRejectionRisk",        limit: 8
    t.string   "txWaitListContact"
    t.decimal  "lowReferralEGFR",                    precision: 6, scale: 1
    t.string   "lowEducationType",       limit: 7
    t.date     "lowAttendeddate"
    t.string   "lowDVD1",                limit: 1
    t.string   "lowDVD2",                limit: 1
    t.string   "lowTxReferralflag",      limit: 1
    t.date     "lowTxReferraldate"
    t.string   "lowHomeHDflag",          limit: 1
    t.string   "lowSelfcareflag",        limit: 1
    t.text     "lowAccessnotes"
    t.date     "pdlinechangedate"
    t.text     "psychsoc_housing"
    t.text     "psychsoc_socialnetwork"
    t.text     "psychsoc_carepackage"
    t.text     "psychsoc_other"
    t.datetime "psychsoc_stamp"
    t.string   "diabetesflag",           limit: 1
    t.string   "hivflag",                limit: 1
    t.date     "endstagedate"
    t.string   "lupusflag",              limit: 1
    t.string   "alertflag",              limit: 1
    t.string   "hbvflag",                limit: 1
    t.string   "hcvflag",                limit: 1
    t.string   "mrsaflag",               limit: 1
    t.date     "mrsadate"
    t.string   "mrsasite",               limit: 40
    t.string   "mrsaposflag",            limit: 1
    t.date     "mrsaposdate"
    t.integer  "mrsalast_id",            limit: 3
    t.string   "akiflag",                limit: 1
  end

  add_index "renaldata", ["mrsalast_id"], name: "mrsalast_id", using: :btree
  add_index "renaldata", ["renalzid"], name: "renalzid", unique: true, using: :btree

  create_table "renalsessions", primary_key: "session_id", force: true do |t|
    t.boolean  "activeflag",                default: true
    t.datetime "starttime"
    t.string   "sessuser",      limit: 20
    t.integer  "sessuid",       limit: 2
    t.string   "user_ipaddr",   limit: 25
    t.string   "agent",         limit: 100
    t.datetime "lasteventtime"
    t.datetime "endtime"
  end

  add_index "renalsessions", ["activeflag"], name: "activeflag", using: :btree
  add_index "renalsessions", ["sessuid"], name: "sessuid", using: :btree

  create_table "rpvlogs", primary_key: "rpv_id", force: true do |t|
    t.string    "hospno1",   limit: 12
    t.timestamp "logstamp",             null: false
    t.string    "rpvstatus", limit: 20
    t.integer   "sequence",  limit: 3
    t.text      "xmltext"
  end

  add_index "rpvlogs", ["hospno1"], name: "hospno1", using: :btree

  create_table "rreg_prdcodes", force: true do |t|
    t.integer "prdcode", limit: 2
    t.string  "prdterm"
  end

  add_index "rreg_prdcodes", ["prdcode"], name: "rregcode", unique: true, using: :btree

  create_table "rregmodalcodes", id: false, force: true do |t|
    t.string "rwarecode", limit: 20
    t.string "rregcode",  limit: 2
  end

  add_index "rregmodalcodes", ["rwarecode"], name: "modalcode", unique: true, using: :btree

  create_table "sharedcaredata", primary_key: "sharedcare_id", force: true do |t|
    t.timestamp "sharedcarestamp",                              null: false
    t.integer   "sharedcareuid",     limit: 2
    t.string    "sharedcareuser",    limit: 20
    t.integer   "sharedcarezid",     limit: 3
    t.date      "sharedcareadddate"
    t.date      "sharedcaredate"
    t.boolean   "currentflag",                  default: true
    t.string    "q1interest",        limit: 1
    t.boolean   "q1participating",              default: false
    t.boolean   "q1completed",                  default: false
    t.string    "q1completed_by",    limit: 20
    t.date      "q1completed_date"
    t.string    "q2interest",        limit: 1
    t.boolean   "q2participating",              default: false
    t.boolean   "q2completed",                  default: false
    t.string    "q2completed_by",    limit: 20
    t.date      "q2completed_date"
    t.string    "q3interest",        limit: 1
    t.boolean   "q3participating",              default: false
    t.boolean   "q3completed",                  default: false
    t.string    "q3completed_by",    limit: 20
    t.date      "q3completed_date"
    t.string    "q4interest",        limit: 1
    t.boolean   "q4participating",              default: false
    t.boolean   "q4completed",                  default: false
    t.string    "q4completed_by",    limit: 20
    t.date      "q4completed_date"
    t.string    "q5interest",        limit: 1
    t.boolean   "q5participating",              default: false
    t.boolean   "q5completed",                  default: false
    t.string    "q5completed_by",    limit: 20
    t.date      "q5completed_date"
    t.string    "q6interest",        limit: 1
    t.boolean   "q6participating",              default: false
    t.boolean   "q6completed",                  default: false
    t.string    "q6completed_by",    limit: 20
    t.date      "q6completed_date"
    t.string    "q7interest",        limit: 1
    t.boolean   "q7participating",              default: false
    t.boolean   "q7completed",                  default: false
    t.string    "q7completed_by",    limit: 20
    t.date      "q7completed_date"
    t.string    "q8interest",        limit: 1
    t.boolean   "q8participating",              default: false
    t.boolean   "q8completed",                  default: false
    t.string    "q8completed_by",    limit: 20
    t.date      "q8completed_date"
    t.string    "q9interest",        limit: 1
    t.boolean   "q9participating",              default: false
    t.boolean   "q9completed",                  default: false
    t.string    "q9completed_by",    limit: 20
    t.date      "q9completed_date"
    t.string    "q10interest",       limit: 1
    t.boolean   "q10participating",             default: false
    t.boolean   "q10completed",                 default: false
    t.string    "q10completed_by",   limit: 20
    t.date      "q10completed_date"
    t.string    "q11interest",       limit: 1
    t.boolean   "q11participating",             default: false
    t.boolean   "q11completed",                 default: false
    t.string    "q11completed_by",   limit: 20
    t.date      "q11completed_date"
    t.string    "q12interest",       limit: 1
    t.boolean   "q12participating",             default: false
    t.boolean   "q12completed",                 default: false
    t.string    "q12completed_by",   limit: 20
    t.date      "q12completed_date"
    t.string    "q13interest",       limit: 1
    t.boolean   "q13participating",             default: false
    t.boolean   "q13completed",                 default: false
    t.string    "q13completed_by",   limit: 20
    t.date      "q13completed_date"
    t.string    "q14interest",       limit: 1
    t.boolean   "q14participating",             default: false
    t.boolean   "q14completed",                 default: false
    t.string    "q14completed_by",   limit: 20
    t.date      "q14completed_date"
  end

  add_index "sharedcaredata", ["currentflag"], name: "currentflag", using: :btree
  add_index "sharedcaredata", ["sharedcareadddate"], name: "sharedcareadddate", using: :btree
  add_index "sharedcaredata", ["sharedcaredate"], name: "sharedcaredate", using: :btree
  add_index "sharedcaredata", ["sharedcareuid"], name: "sharedcareuid", using: :btree
  add_index "sharedcaredata", ["sharedcarezid"], name: "sharedcarezid", using: :btree

  create_table "sitelist", primary_key: "site_id", force: true do |t|
    t.string  "mainsitecode", limit: 6
    t.string  "sitecode",     limit: 16
    t.string  "sitename",     limit: 50
    t.string  "rregcode",     limit: 10
    t.string  "sitetype",     limit: 4
    t.integer "dxbays",       limit: 1
  end

  add_index "sitelist", ["sitecode"], name: "sitecode", unique: true, using: :btree

  create_table "statdata", id: false, force: true do |t|
    t.integer "datazid",   limit: 3,  null: false
    t.string  "datapid",   limit: 10
    t.integer "statcount", limit: 2
  end

  add_index "statdata", ["datapid"], name: "datapid", using: :btree
  add_index "statdata", ["datazid"], name: "datazid", using: :btree

  create_table "tcilistdata", primary_key: "tcilist_id", force: true do |t|
    t.timestamp "tciliststamp",                                   null: false
    t.datetime  "tcilistmodifstamp"
    t.boolean   "activeflag",                      default: true
    t.integer   "tcilistuid",          limit: 2
    t.string    "tcilistuser",         limit: 20
    t.integer   "tcilistzid",          limit: 3
    t.integer   "tciconsult_id",       limit: 3
    t.integer   "tciproced_id",        limit: 3
    t.string    "tcilistmodal",        limit: 20
    t.string    "tcilistsource",       limit: 20
    t.date      "tcilistadddate"
    t.date      "tcilistremovaldate"
    t.string    "tcilistremovalcause", limit: 100
    t.string    "tcireason",           limit: 20
    t.string    "tcipriority",         limit: 20
    t.integer   "tcilistrank",         limit: 2
    t.string    "patlocation",         limit: 50
    t.text      "tcinotes"
  end

  add_index "tcilistdata", ["tciconsult_id"], name: "tciconsult_id", using: :btree
  add_index "tcilistdata", ["tcilistadddate"], name: "tcilistadddate", using: :btree
  add_index "tcilistdata", ["tcilistrank"], name: "tcilistrank", using: :btree
  add_index "tcilistdata", ["tcilistuid"], name: "tcilistuid", using: :btree
  add_index "tcilistdata", ["tcilistzid"], name: "tcilistzid", using: :btree
  add_index "tcilistdata", ["tcipriority"], name: "tcipriority", using: :btree
  add_index "tcilistdata", ["tciproced_id"], name: "tciproced_id", using: :btree

  create_table "timelinedata", primary_key: "timeline_id", force: true do |t|
    t.timestamp "timelinestamp",              null: false
    t.integer   "timelineuid",     limit: 2
    t.string    "timelineuser",    limit: 20
    t.string    "timelinecode",    limit: 20
    t.integer   "timelinezid",     limit: 3
    t.date      "timelineadddate"
    t.string    "timelinedescr",   limit: 60
    t.text      "timelinetext"
  end

  add_index "timelinedata", ["timelinecode"], name: "timelinecode", using: :btree
  add_index "timelinedata", ["timelineuid"], name: "timelineuid", using: :btree
  add_index "timelinedata", ["timelinezid"], name: "timelinezid", using: :btree

  create_table "txbxdata", primary_key: "txbxdata_id", force: true do |t|
    t.integer  "txbxzid",        limit: 3
    t.date     "txbxdate"
    t.string   "txbxresult1"
    t.string   "txbxresult2"
    t.string   "txbxnotes"
    t.datetime "txbxaddstamp"
    t.datetime "txbxmodifstamp"
    t.string   "txbxuser",       limit: 20
    t.integer  "txopid",         limit: 2
  end

  add_index "txbxdata", ["txbxzid"], name: "renalbxzid", using: :btree

  create_table "txinactivepatdata", primary_key: "txinactivepat_id", force: true do |t|
    t.integer  "txinactivepatzid", limit: 3
    t.datetime "assessstamp"
    t.integer  "assessuid",        limit: 2
    t.date     "assessdate"
    t.string   "assessor",         limit: 50
    t.string   "reason1",          limit: 50
    t.string   "reason2",          limit: 50
  end

  add_index "txinactivepatdata", ["txinactivepatzid"], name: "txinactivepatzid", using: :btree

  create_table "txops", primary_key: "txop_id", force: true do |t|
    t.integer  "txopzid",          limit: 3
    t.datetime "txopaddstamp"
    t.datetime "txopmodifstamp"
    t.date     "txopdate"
    t.boolean  "txopno"
    t.string   "txoptype",         limit: 50
    t.integer  "patage",           limit: 1
    t.date     "lastdialdate"
    t.string   "donortype",        limit: 50
    t.string   "donorsex",         limit: 1
    t.date     "donorbirthdate"
    t.string   "donorage",         limit: 12
    t.decimal  "donorweight",                  precision: 3, scale: 1
    t.string   "donor_deathcause", limit: 100
    t.string   "donorHLA"
    t.string   "HLAmismatch"
    t.string   "donorCMVstatus",   limit: 12
    t.string   "recipCMVstatus",   limit: 12
    t.string   "donor_bloodtype",  limit: 6
    t.string   "recip_bloodtype",  limit: 6
    t.string   "kidneyside",       limit: 1
    t.boolean  "kidney_asyst"
    t.string   "txsite",           limit: 12
    t.string   "kidney_age",       limit: 12
    t.decimal  "kidney_weight",                precision: 2, scale: 1
    t.string   "coldinfustime",    limit: 20
    t.boolean  "failureflag"
    t.date     "failuredate"
    t.string   "failurecause"
    t.string   "failuredescr"
    t.date     "stentremovaldate"
    t.string   "graftfxn",         limit: 100
    t.string   "immunosuppneed",   limit: 10
    t.date     "dsa_date"
    t.string   "dsa_result",       limit: 6
    t.string   "dsa_notes"
    t.date     "bkv_date"
    t.string   "bkv_result",       limit: 6
    t.string   "bkv_notes"
  end

  add_index "txops", ["txopzid"], name: "txopzid", using: :btree

  create_table "txwaitlistdata", id: false, force: true do |t|
    t.integer  "txwaitzid",  limit: 3
    t.datetime "eventstamp"
    t.string   "type",       limit: 100
    t.text     "eventtext"
  end

  add_index "txwaitlistdata", ["txwaitzid"], name: "txwaitzid", using: :btree

  create_table "userdata", primary_key: "uid", force: true do |t|
    t.string   "user",                 limit: 20
    t.string   "pass",                 limit: 41
    t.string   "userlast",             limit: 20
    t.string   "userfirst",            limit: 30
    t.boolean  "adminflag",                        default: false
    t.boolean  "consultantflag",                   default: false
    t.boolean  "editflag",                         default: false
    t.boolean  "authorflag",                       default: true
    t.boolean  "clinicflag",                       default: false
    t.boolean  "hdnurseflag",                      default: false
    t.boolean  "decryptflag",                      default: false
    t.boolean  "printflag"
    t.date     "adddate"
    t.date     "expiredate"
    t.datetime "passmodifstamp"
    t.string   "usertype",             limit: 20
    t.string   "email",                limit: 30
    t.string   "sitecode",             limit: 5,   default: "kings"
    t.string   "dept",                 limit: 10,  default: "Renal"
    t.string   "location",             limit: 50
    t.string   "maintel",              limit: 25
    t.string   "directtel",            limit: 25
    t.string   "mobile",               limit: 25
    t.string   "fax",                  limit: 25
    t.string   "inits",                limit: 6
    t.string   "authorsig",            limit: 50
    t.string   "position",             limit: 100
    t.datetime "userstamp"
    t.datetime "modifstamp"
    t.boolean  "logged_inflag",                    default: false
    t.datetime "lastloginstamp"
    t.datetime "lasteventstamp"
    t.boolean  "bedmanagerflag",                   default: false
    t.boolean  "pathflag",                         default: false
    t.string   "startpage"
    t.boolean  "expiredflag",                      default: false
    t.string   "newpwflag",            limit: 1,   default: "0"
    t.boolean  "wardclerkflag",                    default: false
    t.boolean  "transportdeciderflag",             default: false
  end

  add_index "userdata", ["adminflag"], name: "adminflag", using: :btree
  add_index "userdata", ["authorflag"], name: "authorflag", using: :btree
  add_index "userdata", ["clinicflag"], name: "clinicflag", using: :btree
  add_index "userdata", ["consultantflag"], name: "consultantflag", using: :btree
  add_index "userdata", ["decryptflag"], name: "decryptflag", using: :btree
  add_index "userdata", ["editflag"], name: "editflag", using: :btree
  add_index "userdata", ["expiredflag"], name: "expiredflag", using: :btree
  add_index "userdata", ["hdnurseflag"], name: "hdnurseflag", using: :btree
  add_index "userdata", ["logged_inflag"], name: "loginflag", using: :btree
  add_index "userdata", ["user"], name: "user", unique: true, using: :btree

  create_table "viroldata", primary_key: "virol_id", force: true do |t|
    t.integer  "virolzid",           limit: 3,   default: 0, null: false
    t.datetime "viroladdstamp"
    t.datetime "virolmodifstamp"
    t.date     "viroldate"
    t.string   "CMVAbStatus",        limit: 30
    t.date     "CMVAbdate"
    t.string   "EBVstatus",          limit: 30
    t.date     "EBVdate"
    t.string   "HBVsurfaceAbStatus", limit: 30
    t.date     "HBVsurfaceAbdate"
    t.string   "HBVsurfaceAgStatus", limit: 30
    t.date     "HBVsurfaceAgdate"
    t.date     "HBVboosterdate"
    t.string   "HBVcoreAbStatus",    limit: 30
    t.date     "HBVcoreAbdate"
    t.string   "HBVlatestTitre",     limit: 10
    t.date     "HBVlatestTitredate"
    t.date     "HBVvacc1date"
    t.date     "HBVvacc2date"
    t.date     "HBVvacc3date"
    t.date     "HBVvacc4date"
    t.string   "HCV_AbStatus",       limit: 30
    t.date     "HCV_Abdate"
    t.string   "HCV_RNAstatus",      limit: 30
    t.date     "HCV_RNAdate"
    t.string   "HIV_AbStatus",       limit: 30
    t.date     "HIV_Abdate"
    t.integer  "HIVviralload"
    t.date     "HIVviralloaddate"
    t.integer  "HIV_CD4count",       limit: 2
    t.date     "HIV_CD4countdate"
    t.string   "HTLVstatus",         limit: 30
    t.date     "HTLVdate"
    t.string   "HZVstatus",          limit: 30
    t.date     "HZVdate"
    t.text     "virolNotes",         limit: 255
  end

  add_index "viroldata", ["virolzid"], name: "virolzid", unique: true, using: :btree

  create_table "wardlist", primary_key: "wardcode", force: true do |t|
    t.string "sitecode", limit: 6
    t.string "ward",     limit: 50
  end

  add_index "wardlist", ["sitecode"], name: "sitecode", using: :btree

end
