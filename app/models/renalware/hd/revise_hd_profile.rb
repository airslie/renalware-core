module Renalware
  module HD
    class ReviseHDProfile

      def initialize(profile)
        raise(ArgumentError, "Cannot revise a new Profile") unless profile.persisted?
        @profile = profile
      end

      def call(params)
        profile.assign_attributes(params)
        return true unless profile.changed?
        return false unless profile.valid?
        profile.restore_attributes

        profile.supersede!(params)
      end

      private

      attr_reader :profile
    end
  end
end
