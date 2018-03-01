require_dependency "renalware/ukrdc"

module Renalware
  module UKRDC
    class SendPatients
      attr_reader :patient_ids, :changed_since, :logger, :request_uuid

      def initialize(changed_since: nil, patient_ids: nil, logger: nil)
        @changed_since = Time.zone.parse(changed_since) if changed_since.present?
        @patient_ids = Array(patient_ids)
        @logger = logger || Rails.logger
        @request_uuid = SecureRandom.uuid # helps group logs together
      end

      def call
        logger.info "Request #{request_uuid}"

        ms = Benchmark.ms do
          send_patients
        end
        print_summary(ms)
      end

      private

      def send_patients
        logger.info("Generating XML files for #{patient_ids&.any? ? patient_ids : 'all'} patients")
        query = Renalware::UKRDC::PatientsQuery.new.call(changed_since: changed_since)
        query = query.where(id: Array(patient_ids)) if patient_ids.present?

        if changed_since.present?
          logger.info("#{query.count} patients have changed since #{changed_since}")
        else
          logger.info("#{query.count} patients have changed since the last send")
        end

        folder_name = within_new_folder do |dir|
          xml_path = dir.join("xml")
          query.all.find_each do |patient|
            SendPatient.new(
              patient: patient,
              dir: xml_path,
              changes_since: changed_since,
              request_uuid: request_uuid,
              logger: logger
            ).call
          end
        end
        logger.info("Files saved to #{folder_name}")
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

      def print_summary(ms)
        logger.info "*** Summary ***"
        logger.info "Took #{ms.to_i / 1000} seconds"
        results = TransmissionLog.where(request_uuid: request_uuid).group(:status).count(:status)
        results.to_h.map{ |key, value| logger.info("#{key}: #{value}") }
      end
    end
  end
end
