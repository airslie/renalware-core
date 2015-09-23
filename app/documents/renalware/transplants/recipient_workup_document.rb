module Renalware
  module Transplants
    class RecipientWorkupDocument < Document::Base
      attribute :hx_tb, Boolean
      attribute :hx_dvt, Boolean
      attribute :hx_reflux, Boolean
      attribute :hx_neurogenic_bladder, Boolean
      attribute :hx_recurrent_utis, Boolean
      attribute :hx_family_diabetes, Boolean
      attribute :pregnancies_no, Integer
      attribute :cervical_result, String
      attribute :cervical_date, Date
      attribute :femoral_pulse_r, Boolean
      attribute :femoral_pulse_l, Boolean
      attribute :dorsalis_pedis_pulse_r, Boolean
      attribute :dorsalis_pedis_pulse_l, Boolean
      attribute :posterior_tibial_pulse_r, Boolean
      attribute :posterior_tibial_pulse_l, Boolean
      attribute :bruits, String
      attribute :heart_sounds, String
      attribute :tx_consent, Boolean
      attribute :tx_consent_date, Date
      attribute :tx_consent_marginal, Boolean
      attribute :tx_consent_marginal_date, Date

      validates_presence_of :tx_consent_date, if: :tx_consent
      validates_presence_of :tx_consent_marginal_date, if: :tx_consent_marginal
    end
  end
end