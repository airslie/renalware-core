require_dependency "renalware/pd"

module Renalware
  module PD
    module APD
      class GlucoseCalculator
        attr_reader :regime, :bags
        delegate :overnight_volume, to: :regime

        def initialize(regime:, percent:)
          @regime = regime
          @bags = bags_having_glucose_percentage(regime.bags, percent)
        end

        # See calculating_apd_volumes.feature for a description of the algorithm here.
        def glucose_content
          glucose = overnight_bags.inject(0) do |total, bag|
            total + glucose_for_bag(bag).to_i
          end
          glucose + (other_content / 7)
        end

        private

        # rubocop:disable Metrics/LineLength
        def glucose_for_bag(bag)
          (((bag.volume.to_f * bag.days_per_week.to_f) / available_overnight_volume.to_f) * overnight_volume) / 7
        end
        # rubocop:enable Metrics/LineLength

        def available_overnight_volume
          @available_overnight_volume ||= AvailableOvernightVolume.new(regime: regime).value
        end

        def other_content
          other_bags.inject(0) do |sum, bag|
            sum + (bag.volume * bag.days_per_week)
          end.to_f
        end

        def overnight_bags
          bags.select(&:ordinary?)
        end

        def other_bags
          bags - overnight_bags
        end

        def bags_having_glucose_percentage(bags, percent)
          bags.select{ |bag| bag.bag_type.glucose_content == percent }
        end
      end
    end
  end
end
