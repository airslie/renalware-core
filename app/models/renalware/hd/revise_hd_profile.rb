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

        save(params)
      end

      private
      attr_reader :profile

      def save(params)
        Profile.transaction do
          deactivate_old_profile(params)
          create_new_active_profile(params)
        end
      end

      def deactivate_old_profile(params)
        profile.restore_attributes
        profile.active = nil
        profile.by = params[:by]
        profile.save!
      end

      def create_new_active_profile(params)
        new_profile = profile.dup
        new_profile.assign_attributes(params)
        new_profile.active = true
        new_profile.by = params[:by]
        new_profile.save!
      end
    end
  end
end
