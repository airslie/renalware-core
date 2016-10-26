module World
  module HD::Session
    module Domain
      def create_dna_session(options)
        seed_dna_session(options)
      end

      def seed_dna_session(options)
        options = parse_options(options)
        Renalware::HD::Session::DNA.create!(options)
      end

      def expect_dna_session_to_exist(patient:)
        expect(Renalware::HD::Session::DNA.for_patient(patient)).to be_present
      end

      private

      def parse_options(options)
        options[:patient] = hd_patient(options[:patient])
        options[:signed_on_by] = options[:by] = options.delete(:user)
        options.reverse_merge!(default_dna_session_options)
      end

      def default_dna_session_options
        {
          notes: "none",
          hospital_unit: Renalware::Hospitals::Unit.hd_sites.first,
          start_time: "11:30",
          performed_on: Time.zone.today
        }
      end
    end

    module Web
      include Domain

      def create_dna_session(options)
        user = options.delete(:user)
        patient = options.delete(:patient)
        login_as user
        visit patient_hd_dashboard_path(patient)
        within_fieldset t_sessions(:title) do
          click_on t_sessions(:add_dna_session)
        end

        fill_in t_form(".start_time"), with: "13:00"
        select hd_unit.to_s, from: t_form(".hospital_unit")
        fill_in t_form(".performed_on"), with: I18n.l(options[:performed_on])
        within ".form_actions" do
          click_on t_form(".save")
        end

        expect(page.current_path).to eq(patient_hd_dashboard_path(patient))
        expect_dna_session_to_exist(patient: patient)
      end

      private

      def t_sessions(key)
        I18n.t!(key, scope: "renalware.hd.sessions.list")
      end

      def t_form(key)
        I18n.t!(key, scope: "activerecord.attributes.renalware/hd/session")
      rescue I18n::MissingTranslationData
        I18n.t(key, scope: "renalware.hd.sessions.dna.form")
      end
    end
  end
end
