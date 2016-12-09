require_dependency "renalware/pd"

module Renalware
  module PD
    module APD
      class TidalRegimeCalculations < SimpleDelegator
        INCALCULABLE = nil

        def overnight_volume
          return INCALCULABLE unless overnight_volume_calculable?
          if drain_every_three_cycles?
            volume_when_1st_and_then_every_3rd_exchange_is_full_and_the_remainder_are_tidal
          else
            volume_when_first_exchange_is_full_and_the_remainder_are_tidal
          end
        end

        private

        def overnight_volume_calculable?
          raise ArgumentError, "Tidal indicator not set" unless tidal?
          fill_volume.to_i > 0 && cycles.to_i > 0 && tidal_percentage.to_i > 0
        end

        def volume_when_1st_and_then_every_3rd_exchange_is_full_and_the_remainder_are_tidal
          complete_fills = number_of_complete_fills_if_draining_every_three_cycles
          partial_fills = cycles - complete_fills
          volume_when(complete_fills: complete_fills, partial_fills: partial_fills)
        end

        def volume_when_first_exchange_is_full_and_the_remainder_are_tidal
          volume_when(complete_fills: 1, partial_fills: cycles - 1)
        end

        def volume_when(complete_fills:, partial_fills:)
          vol = (complete_fills * fill_volume) + (partial_fills * (fill_volume * tidal_multiplier))
          vol.to_i
        end

        def number_of_complete_fills
          if drain_every_three_cycles?
            number_of_complete_fills_if_draining_every_three_cycles
          else
            1
          end
        end

        def number_of_complete_fills_if_draining_every_three_cycles
          case cycles
          when 1..3 then 1
          when 4..6 then 2
          when 7..9 then 3
          when 10..12 then 4
          else raise NotImplementedError
          end
        end

        # 75 (%) becomes 0.75
        def tidal_multiplier
          tidal_percentage.to_f / 100.0
        end
      end
    end
  end
end
