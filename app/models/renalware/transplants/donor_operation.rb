require_dependency "renalware/transplants"
require "document/base"

module Renalware
  module Transplants
    class DonorOperation < ActiveRecord::Base
      include Document::Base
      include PatientScope
      extend Enumerize

      belongs_to :patient

      scope :ordered, -> { order(performed_on: :asc) }
      scope :reversed, -> { order(performed_on: :desc) }

      has_paper_trail class_name: "Renalware::Transplants::DonorOperationVersion"
      has_document class_name: "Renalware::Transplants::DonorOperationDocument"

      enumerize :kidney_side, in: %i(left right both)
      enumerize :operating_surgeon, in: %i(consultant fellow_senior_registrar other)
      enumerize :anaesthetist, in: %i(consultant fellow_senior_registrar other)
      enumerize :nephrectomy_type, in: %i(
        open_transperitoneal open_loin_with_resection open_loin_without_resection
        open_extraperitoneal laparoscropic_intra laparoscropic_extra other)
      enumerize :donor_splenectomy_peri_or_post_operatively, in: %i(yes no unknown)

      validates :performed_on, presence: true
    end
  end
end