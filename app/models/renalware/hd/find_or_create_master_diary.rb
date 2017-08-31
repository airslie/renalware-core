module Renalware
  module HD
    class FindOrCreateMasterDiary
      attr_reader :unit_id, :user

      def self.for_unit(unit_id, user)
        new(unit_id, user).call
      end

      def initialize(unit_id, user)
        @unit_id = unit_id
        @user = user
      end

      # TODO: !alwasy suing first :0)
      def call
        MasterDiary.find_or_initialize_by(hospital_unit_id: unit_id).tap do |master|
          master.by = user
          master.save!
        end
      end
    end
  end
end
