module World
  module PD::APDRegime
    module Domain
      def build_apd_regime_for(patient:, user:, data:)
        regime = Renalware::PD::APDRegime.new(patient: patient)
        data.each do |key, value|
          regime.public_send("#{key.to_sym}=", value)
        end
        regime.treatment ||= "A treatment"
        regime
      end

      def add_bags_to_regime(regime:, user:, data:)
        data.each do |attrs|
          bag = regime.bags.new
          bag.bag_type = bag_type_with(glucose_content: attrs[:glucose_content].to_f)
          bag.role = attrs[:role].to_sym
          bag.volume = attrs[:volume]
          reset_all_days_to_false_for(bag: bag)
          set_selected_days_to_true_for_bag(bag: bag, comma_delimited_days_string: attrs[:days])
        end
        regime.save!
      end

      def expect_calculated_regime_volumes_to_be(data:, regime:)
        regime.save!
        data.each do |key, value|
          expect(regime.public_send(key.to_sym).to_s).to eq(value)
        end
      end

      private

      def reset_all_days_to_false_for(bag:)
        Date::DAYNAME_SYMBOLS.map do |day|
          bag.public_send("#{day}=", false)
        end
      end

      def set_selected_days_to_true_for_bag(bag:, comma_delimited_days_string:)
        days = comma_delimited_days_string.split(",")
        days.each do |day|
          bag.public_send("#{day}=".to_sym, true)
        end
        expect(bag.days_per_week).to eq(days.length)
      end

      def bag_type_with(glucose_content:)
        # TL;DR: Coercing glucose_content to_s because where(glucose_content: 1.36) returns no rows
        # even though the raw query in the log, run in pgadmin, works fine. AR doing something odd.
        #
        # Since migrating to Rails 5, querying the glucose_content column *for some reason*
        # won't work using a float on the RHS. Works for sodium_content, not for glucose_content
        # even though they are similarly defined. IN fact sodium_content is numeric(3,2) and
        # glucose_content numeric(4,2) but changing it numeric(3,2) doesn't help. Its odd.
        # Hence the #to_s which means I presume that AR will not get to misinterpret it and
        # it will leave pg to query with it and get it right.
        Renalware::PD::BagType.find_by!(glucose_content: glucose_content.to_s)
      end
    end

    module Web
      include Domain

      # WIP
      # def build_apd_regime_for(patient:, user:, data:)
      #   data = data.to_h
      #   login_as user
      #   visit new_patient_pd_apd_regime_path(patient)
      #   fill_in "* Start date", with: data["start_date"]
      #   select("APD Wet Day", from: "Treatment")
      #   fill_in("* Cycles per session", with: data["cycles"])
      #   fill_in("* Fill volume (ml)", with: data["fill_volume"])
      #   fill_in("Last fill volume (ml)", with: data["last_fill_volume"])
      #   fill_in("Add'l man exchange vol (ml)", with: data["additional_manual_exchange_volume"])
      # end

      # WIP
      # def add_bags_to_regime(regime:, user:, data:)
      #   data.each do |attrs|
      #     find("a.add-bag").click && wait_for_ajax
      #      within(".fields:last-child") do
      #        select attrs["volume"], from: "Volume (ml)"
      #        select attrs["name"], from: "* Bag type"
      #      end
      #   end
      # end
    end
  end
end
