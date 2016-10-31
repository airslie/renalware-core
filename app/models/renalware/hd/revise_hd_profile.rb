module Renalware
  module HD
    class ReviseHDProfile

      def initialize(profile)
        @profile = profile
      end

      def call(params)
        profile.assign_attributes(params)
        return true unless profile.changed?
        return false unless profile.valid?

        duplicate_profile_with(params)
      end

      private
      attr_reader :profile

      def duplicate_profile_with(params)
        new_profile = profile.dup
        new_profile.assign_attributes(params)
        new_profile.save!
      end
    end
  end
end
