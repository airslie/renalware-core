require_dependency "renalware/accesses"

module Renalware
  module Accesses
    class Procedure < ActiveRecord::Base
      include Accountable
      extend Enumerize

      belongs_to :patient
      belongs_to :type, class_name: "Type"
      belongs_to :site, class_name: "Site"
      belongs_to :performed_by, class_name: "User", foreign_key: "performed_by_id"

      has_paper_trail class_name: "Renalware::Accesses::Version"

      scope :ordered, -> { order(performed_on: :desc) }

      validates :type, presence: true
      validates :site, presence: true
      validates :side, presence: true
      validates :performed_by, presence: true
      validates :performed_on, presence: true
      validates :performed_on, timeliness: { type: :date, allow_blank: false }
      validates :first_used_on, timeliness: { type: :date, allow_blank: true }
      validates :failed_on, timeliness: { type: :date, allow_blank: true }

      enumerize :side, in: %i(left right)
    end
  end
end