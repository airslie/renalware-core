FactoryGirl.define do
  factory :pd_regime do
    patient
    start_date "01/02/2015"
    end_date "01/02/2015"
    glucose_ml_percent_1_36 10
    glucose_ml_percent_2_27 20
    glucose_ml_percent_3_86 30
    amino_acid_ml 40
    icodextrin_ml 50
    low_glucose_degradation true
    low_sodium false
    additional_hd false
  end

end
