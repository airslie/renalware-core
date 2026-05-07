# frozen_string_literal: true

module Renalware
  module Heroic
    module Events
      class Mri < HeroicEvent
        class Document < Heroic::Document
          MAX_VISIT_NUMBER = 3
          attribute :visit_number, Integer
          %i(
            r2_cortex
            r2_medulla
            diffusion_adc_cortex_continuous
            diffusion_adc_medulla_continuous
            diffusion_ivim_model_cortex_continuous
            diffusion_ivim_model_medulla_continuous
            r1_cortex_continuous
            r1_medulla_continuous
            t2_mapping_continuous
            rari_continuous
            mean_arterial_flow_continuous
            peak_velocity_min_continuous
            peak_velocity_max_continuous
            pc_perfusion_continuous
            cortical_volume_continuous
            kidney_volume_corrected_for_body_surface_area_continuous
            lv_global_longitudinal_strain_continuous
            lv_global_radial_strain_continuous
            lv_global_circumferential_strain_continuous
            lv_global_diastolic_longitudinal_strain_rate_continuous
            lv_global_systolic_longitudinal_strain_rate_continuous
            lv_global_diastolic_radial_strain_rate_continuous
            lv_global_systolic_radial_strain_rate_continuous
            lv_global_diastolic_circumferential_strain_rate_continuous
            lv_global_systolic_circumferential_strain_rate_continuous
            lv_stroke_volume_continuous
            lv_end_diastolic_volume_continuous
            lv_end_systolic_volume_continuous
            lv_mass_continuous
            lv_mass_end_diastolic_volume_continuous
            lv_ejection_fraction_continuous
            pulse_wave_velocity_continuous
            lean_muscle_mass_continuous
          ).each do |attr_name|
            attribute attr_name, Float
            validates attr_name, numericality: true, allow_nil: true
          end

          attribute :renal_artery_atherosclerosis_ordinal, Integer
          validates(
            :renal_artery_atherosclerosis_ordinal,
            numericality: { only_integer: true },
            allow_nil: true
          )

          validates(
            :visit_number,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: MAX_VISIT_NUMBER
            },
            allow_nil: true
          )
        end
        has_document
      end
    end
  end
end
