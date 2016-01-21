require_dependency "renalware/accesses"

module Renalware
  module Accesses
    class Access < ActiveRecord::Base
      belongs_to :source, polymorphic: true
      belongs_to :description, class_name: "Description"
      belongs_to :site, class_name: "Site"

      validates :source, presence: true
      validates :description, presence: true
      validates :site, presence: true
      validates :side, presence: true
    end
  end
end
