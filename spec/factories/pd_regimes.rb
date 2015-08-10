FactoryGirl.define do
  factory :pd_regime do
    patient
  end

  factory :capd_regime, class: CapdRegime, parent: :pd_regime do
    patient
    start_date "01/02/2015"
    end_date "01/02/2015"
    treatment "CAPD 3 exchanges per day"
    amino_acid_ml 40
    icodextrin_ml 50
    add_hd false
  end

  factory :apd_regime, class: ApdRegime, parent: :pd_regime do
    patient
    start_date "01/03/2015"
    end_date "02/04/2015"
    treatment "APD Wet day with additional exchange"
    amino_acid_ml 43
    icodextrin_ml 53
    add_hd true
    last_fill_ml 630
    add_manual_exchange true
    tidal_indicator true
    tidal_percentage 30
    no_cycles_per_apd 2
    overnight_pd_ml 5100
  end

end
