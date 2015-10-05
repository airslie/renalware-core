module Renalware
  module Transplants
    class RecipientWorkupDocument < Document::Base
      attribute :angina
      attribute :angina_date, Date
      attribute :myocardial_infarct
      attribute :myocardial_infarct_date, Date
      attribute :coronary_artery_bypass_graft
      attribute :coronary_artery_bypass_graft_date, Date
      attribute :heart_failure
      attribute :heart_failure_date, Date
      attribute :smoking
      attribute :smoking_date, Date
      attribute :chronic_obstr_pulm_dis
      attribute :chronic_obstr_pulm_dis_date, Date
      attribute :cvd_or_stroke
      attribute :cvd_or_stroke_date, Date
      attribute :diabetes
      attribute :diabetes_date, Date
      attribute :malignancy
      attribute :malignancy_date, Date
      attribute :liver_disease
      attribute :liver_disease_date, Date
      attribute :claudication
      attribute :claudication_date, Date
      attribute :ischaemic_neuropathic_ulcers
      attribute :ischaemic_neuropathic_ulcers_date, Date
      attribute :non_coronary_angioplasty
      attribute :non_coronary_angioplasty_date, Date
      attribute :amputation_for_pvd
      attribute :amputation_for_pvd_date, Date

      attribute :hx_tb
      attribute :hx_dvt
      attribute :hx_reflux
      attribute :hx_neurogenic_bladder
      attribute :hx_recurrent_utis
      attribute :hx_family_diabetes

      attribute :pregnancies_count, Integer

      attribute :karnofsky_score, Integer
      attribute :prisma_score, Integer

      attribute :cervical_result
      attribute :cervical_date, Date

      attribute :femoral_pulse_r
      attribute :femoral_pulse_l
      attribute :dorsalis_pedis_pulse_r
      attribute :dorsalis_pedis_pulse_l
      attribute :posterior_tibial_pulse_r
      attribute :posterior_tibial_pulse_l

      attribute :carotid_bruit_l
      attribute :carotid_bruit_r
      attribute :femoral_bruit_l
      attribute :femoral_bruit_r
      attribute :heart_sounds

      attribute :tx_consent
      attribute :tx_consenting_name
      attribute :tx_consent_date, Date
      attribute :tx_marginal_consent
      attribute :tx_marginal_consenting_name
      attribute :tx_marginal_consent_date, Date
      old_attributes :tx_consent_marginal, :tx_consent_marginal_date

      attribute :educ_waiting_list
      attribute :educ_transport_benefits
      attribute :educ_procedure
      attribute :educ_infection
      attribute :educ_rejection
      attribute :educ_success_rate
      attribute :educ_drugs_shortterm
      attribute :educ_drugs_longterm
      attribute :educ_cancer
      attribute :educ_followup
      attribute :educ_recurrence

      attribute :hla_data

      validates :tx_consent, inclusion: { in: %w(full partial refused), allow_blank: true }
      validates :tx_consent_date, presence: true, if: "tx_consent.present?"
      validates :tx_consenting_name, presence: true, if: "tx_consent.present?"
      validates :tx_marginal_consenting_name, presence: true,
        if: Proc.new { |o| %w(yes no).include? o.tx_marginal_consent }
      validates :tx_marginal_consent_date, presence: true,
        if: Proc.new { |o| %w(yes no).include? o.tx_marginal_consent }

      validates :karnofsky_score, inclusion: { in: 0..100, allow_blank: true }
      validates :prisma_score, inclusion: { in: 0..7, allow_blank: true }
    end
  end
end
