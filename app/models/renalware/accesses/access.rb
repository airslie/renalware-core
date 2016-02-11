require_dependency "renalware/accesses"

module Renalware
  module Accesses
    class Access < ActiveRecord::Base
      include PatientScope
      include Accountable
      extend Enumerize

      belongs_to :patient
      belongs_to :type, class_name: "Type"
      belongs_to :site, class_name: "Site"

      has_paper_trail class_name: "Renalware::Accesses::Version"

      validates :type, presence: true
      validates :site, presence: true
      validates :side, presence: true
      validates :formed_on, timeliness: { type: :date, allow_blank: true }
      validates :started_on, timeliness: { type: :date, allow_blank: true }
      validates :terminated_on, timeliness: { type: :date, allow_blank: true }

      enumerize :side, in: %i(left right)
    end
  end
end
