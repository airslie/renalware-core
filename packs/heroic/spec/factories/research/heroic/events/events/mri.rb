# frozen_string_literal: true

FactoryBot.define do
  factory :heroic_mri_event, class: "Renalware::Heroic::Events::Mri", parent: :event do
    event_type factory: :heroic_mri_event_type

    document {
      {
        visit_number: 0,
        r2_cortex: 1.1,
        r2_medulla: 1.1,
        diffusion_adc_cortex_continuous: 1.1,
        diffusion_adc_medulla_continuous: 1.1,
        diffusion_ivim_model_cortex_continuous: 1.1,
        diffusion_ivim_model_medulla_continuous: 1.1,
        r1_cortex_continuous: 1.1,
        r1_medulla_continuous: 1.1,
        t2_mapping_continuous: 1.1,
        rari_continuous: 1.1,
        mean_arterial_flow_continuous: 1.1,
        peak_velocity_min_continuous: 1.1,
        peak_velocity_max_continuous: 1.1,
        pc_perfusion_continuous: 1.1,
        cortical_volume_continuous: 1.1,
        kidney_volume_corrected_for_body_surface_area_continuous: 1.1,
        lv_global_longitudinal_strain_continuous: 1.1,
        lv_global_radial_strain_continuous: 1.1,
        lv_global_circumferential_strain_continuous: 1.1,
        lv_global_diastolic_longitudinal_strain_rate_continuous: 1.1,
        lv_global_systolic_longitudinal_strain_rate_continuous: 1.1,
        lv_global_diastolic_radial_strain_rate_continuous: 1.1,
        lv_global_systolic_radial_strain_rate_continuous: 1.1,
        lv_global_diastolic_circumferential_strain_rate_continuous: 1.1,
        lv_global_systolic_circumferential_strain_rate_continuous: 1.1,
        lv_stroke_volume_continuous: 1.1,
        lv_end_diastolic_volume_continuous: 1.1,
        lv_end_systolic_volume_continuous: 1.1,
        lv_mass_continuous: 1.1,
        lv_mass_end_diastolic_volume_continuous: 1.1,
        lv_ejection_fraction_continuous: 1.1,
        pulse_wave_velocity_continuous: 1.1,
        lean_muscle_mass_continuous: 1.1,
        renal_artery_atherosclerosis_ordinal: 1
      }
    }
  end
end
