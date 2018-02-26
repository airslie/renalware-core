require_dependency "renalware/ukrdc"

module Renalware
  module UKRDC
    class SendPatients
      attr_reader :patient_ids, :changed_since

      def initialize(changed_since: nil, patient_ids: nil)
        @changed_since = DateTime.parse(changed_since) if changed_since.present?
        @patient_ids = patient_ids
      end

      def call
        #puts "Generating XML files for #{patient_ids&.any? ? patient_ids : 'all'} patients"
        query = Renalware::UKRDC::PatientsQuery.new.call(changed_since: changed_since)
        query = query.where(id: Array(patient_ids)) if patient_ids.present?

        folder_name = within_new_folder do |dir|
          query.all.find_each do |patient|
            SendPatient.new(patient, dir, changed_since).call
          end
        end
      end

      private

      def render_xml_for(patient)
        renderer.render(
          "renalware/api/ukrdc/patients/show",
          locals: { patient: presenter_for(patient) }
        )
      end

      def gpg_encrypt(filepath, output_filepath)
        path_to_key = File.open(Rails.root.join("key.gpg"))
        # only needed if the key has not been imported previously
        GPGME::Key.import(path_to_key)
        crypto = GPGME::Crypto.new(always_trust: true)
        File.open(filepath) do |in_file|
          File.open(output_filepath, "wb") do |out_file|
            crypto.encrypt in_file, output: out_file, recipients: "Patient View"
          end
        end
      end

      def presenter_for(patient)
        Renalware::UKRDC::PatientPresenter.new(patient)
      end

      def renderer
        @renderer ||= Renalware::API::UKRDC::PatientsController.renderer
      end

      def timestamp
        Time.zone.now.strftime("%Y%m%d%H%M%S%L")
      end

      def within_new_folder
        dir = Rails.root.join("tmp", timestamp)
        FileUtils.mkdir_p dir
        FileUtils.mkdir_p File.join(dir, "xml")
        FileUtils.mkdir_p File.join(dir, "encrypted")
        yield dir if block_given?
        dir
      end

      def filepath_for(patient, dir, sub_folder)
        raise(ArgumentError, "Patient has no ukrdc_external_id") if patient.ukrdc_external_id.blank?
        filename = "#{patient.ukrdc_external_id}.xml"
        File.join(dir, sub_folder.to_s, filename)
      end
    end
  end
end
