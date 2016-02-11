require_dependency "renalware/accesses"

module Renalware
  module Accesses
    class Access < ActiveRecord::Base
      belongs_to :type, class_name: "Type"
      belongs_to :site, class_name: "Site"

      validates :type, presence: true
      validates :site, presence: true
      validates :side, presence: true
    end
  end
end
