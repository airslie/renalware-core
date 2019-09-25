# frozen_string_literal: true

require "benchmark"

namespace :pd do
  desc "Applies the PD Calculations that are normally done when a user saves a regime. "\
       "Useful post-migration to populate calculated fields. "\
       "We avoid changing the updated_at timestamp in this instance, so it is recommended "\
       "to clear the cache after running, otherwise the PD Summary etc in the UI may not update "\
       "becuase some cache keys are based on the regime.updated_at column."
  # Note if this task fails because the underlying PD regime data is not valid (we call save! so
  # validations run) an alternative is to do this, which you even do in the rails console:
  #   regimes.each { |r| Renalware::PD::APD::CalculateVolumes.new(r).call }
  #   regimes = Renalware::PD::APDRegime.where(daily_volume: nil);
  #   regimes.each { |r| r.update_columns(overnight_volume: r.overnight_volume,
  #     daily_volume: r.daily_volume,
  #     glucose_volume_low_strength: r.glucose_volume_low_strength,
  #     glucose_volume_medium_strength: r.glucose_volume_medium_strength,
  #     glucose_volume_high_strength: r.glucose_volume_high_strength) }
  task apply_calculations: :environment do
    Rails.logger = Logger.new(STDOUT)
    # Apply to regimes where the calcs have not been run - ie one of the calculated columns is null.
    regimes = Renalware::PD::APDRegime.where(daily_volume: nil).order(created_at: :asc)
    Rails.logger.info "Applying calcs to #{regimes.count} regimes"
    regimes.find_in_batches(batch_size: 50).each do |batch|
      batch.each do |regime|
        Rails.logger.info "Updating regime##{regime.id}"
        regime.save!(touch: false) # don't change updated_at column
      end
    end
  end
end
