# frozen_string_literal: true

require_dependency "renalware/ukrdc"
require "gpg_encrypt_folder"

module Renalware
  module UKRDC
    # Using a working folder with a timestamp name, find matching patients and for each, generate
    # an XML file (see UKRDC Schema) containing changes since the last time we sent the URDC data
    # about them. Encrypt the xml files and copy to an outgoing folder
    # which might for example be a symlink to an outgoing folder in /mmedia/ukrdc which in turn
    # is mount on a remote share for example on an SFTP server.
    class CreateEncryptedPatientXMLFiles
      attr_reader :patient_ids, :changed_since, :logger, :request_uuid, :paths, :timestamp

      def initialize(changed_since: nil, patient_ids: nil, logger: nil)
        @changed_since = Time.zone.parse(changed_since) if changed_since.present?
        @patient_ids = Array(patient_ids)
        @logger = logger || Rails.logger
        @request_uuid = SecureRandom.uuid # helps group logs together
        @timestamp = Time.zone.now.strftime("%Y%m%d%H%M%S%L")
        @paths = Paths.new(timestamp: @timestamp, working_path: config.ukrdc_working_path)
      end

      def call
        logger.tagged(request_uuid) do
          ms = Benchmark.ms do
            create_patient_xml_files
            encrypt_patient_xml_files
            copy_encrypted_xml_files_into_the_outgoing_folder
            paths.create_symlink_to_latest_timestamped_folder_so_it_is_easier_to_eyeball
          end
          print_summary(ms)
        end
      rescue StandardError => exception
        notify_exception(exception)
        raise exception
      end

      private

      def notify_exception(exception)
        Engine.exception_notifier.notify(exception)
      end

      def create_patient_xml_files
        ukrdc_patients_who_have_changed_since_last_send.find_each do |patient|
          CreatePatientXMLFile.new(
            patient: patient,
            dir: paths.timestamped_xml_folder,
            changes_since: changed_since,
            request_uuid: request_uuid,
            logger: logger
          ).call
        end
      end

      # rubocop:disable Metrics/AbcSize
      def ukrdc_patients_who_have_changed_since_last_send
        logger.info("Finding #{patient_ids&.any? ? patient_ids : 'all ukrdc'} patients")
        query = Renalware::UKRDC::PatientsQuery.new.call(changed_since: changed_since)
        query = query.where(id: Array(patient_ids)) if patient_ids.present?

        if changed_since.present?
          logger.info("#{query.count} patients have changed since #{changed_since}")
        else
          logger.info("#{query.count} patients have changed since the last send")
        end

        query.all
      end
      # rubocop:enable Metrics/AbcSize

      # rubocop:disable Metrics/AbcSize
      def print_summary(ms)
        logger.info("Files saved to #{paths.timestamped_folder}")
        logger.info "*** Summary ***"
        logger.info "Took #{ms.to_i / 1000} seconds"
        results = TransmissionLog.where(request_uuid: request_uuid).group(:status).count(:status)
        results.to_h.map{ |key, value| logger.info("#{key}: #{value}") }
      end
      # rubocop:enable Metrics/AbcSize

      def encrypt_patient_xml_files
        logger.info "Encrypting..."
        GpgEncryptFolder.new(folder: paths.timestamped_xml_folder, options: gpg_options).call
      end

      def copy_encrypted_xml_files_into_the_outgoing_folder
        encrypted_files = Dir.glob(paths.timestamped_encrypted_folder.join("*.*"))
        FileUtils.cp_r(encrypted_files, paths.outgoing_folder) if encrypted_files.any?
      end

      def config
        Renalware.config
      end

      def gpg_options
        GpgOptions.new(
          recipient: config.ukrdc_gpg_recipient,
          keyring: config.ukrdc_gpg_keyring,
          homedir: config.ukrdc_gpg_homedir,
          destination_folder: paths.timestamped_encrypted_folder,
          timestamp: timestamp
        )
      end
    end
  end
end
