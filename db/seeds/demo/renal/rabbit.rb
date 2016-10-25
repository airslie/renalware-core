module Renalware
  log "Adding Renal Profile and Comorbidities for Roger RABBIT"

  Renal::Profile.create!(
    patient_id: 1,
    esrf_on: 17.weeks.ago,
    first_seen_on: 18.weeks.ago,
    prd_description_id: 142,
    comorbidities_updated_on: 1.week.ago,
    document: {
      comorbidities: {
        angina: {status: "yes", confirmed_on_year: 2003},
        smoking: {status: "yes", confirmed_on_year: 1993},
        diabetes: {status: "yes", confirmed_on_year: 2005},
        malignancy: {status: "yes", confirmed_on_year: 2014},
        claudication: {status: "no", confirmed_on_year: ""},
        cvd_or_stroke: {status: "no", confirmed_on_year: ""},
        heart_failure: {status: "no", confirmed_on_year: ""},
        liver_disease: {status: "no", confirmed_on_year: ""},
        amputation_for_pvd: {status: "no", confirmed_on_year: ""},
        myocardial_infarct: {status: "no", confirmed_on_year: ""},
        chronic_obstr_pulm_dis: {status: "yes", confirmed_on_year: 2000},
        non_coronary_angioplasty: {status: "no", confirmed_on_year: ""},
        coronary_artery_bypass_graft: {status: "no", confirmed_on_year: ""},
        ischaemic_neuropathic_ulcers: {status: "no", confirmed_on_year: ""}
      }
    }
  )
end
