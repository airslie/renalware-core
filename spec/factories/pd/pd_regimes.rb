FactoryGirl.define do
  factory :pd_regime, class: "Renalware::PD::Regime" do
    patient
  end

  factory :capd_regime, class: "Renalware::PD::CAPDRegime" do
    patient
    start_date "01/02/2015"
    end_date "01/02/2015"
    treatment "CAPD 3 exchanges per day"
    amino_acid_volume 40
    icodextrin_volume 50
    add_hd false
  end

  factory :apd_regime, class: "Renalware::PD::APDRegime" do
    patient
    start_date "01/03/2015"
    end_date "02/04/2015"
    treatment "APD Wet day with additional exchange"
    amino_acid_volume 43
    icodextrin_volume 53
    add_hd true
    last_fill_volume 630
    add_manual_exchange true
    tidal_indicator true
    tidal_percentage 30
    no_cycles_per_apd 2
    overnight_pd_volume 5100
    apd_machine_pac "123-4567-890"
  end

end
