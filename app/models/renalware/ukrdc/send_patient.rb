require_dependency "renalware/ukrdc"
require "attr_extras"

module Renalware
  module UKRDC
    class SendPatient
      pattr_initialize [:patient!, :dir!, :request_uuid!, :renderer, :changes_since, :logger]

      def call
        UKRDC::TransmissionLog.with_logging(patient, request_uuid) do |log|
          logger.info "  Patient #{patient.to_param}"
          xml_payload = build_payload(log)
          if xml_payload_same_as_last_sent_payload?(xml_payload)
            log.unsent_no_change_since_last_send!
          else
            send_file(xml_payload, log)
          end
          logger.info "    Status: #{log.status}"
        end
      end

      private

      def logger
        @logger ||= Rails.logger
      end

      def xml_payload_same_as_last_sent_payload?(payload)
        payload.to_md5_hash == last_sent_transmission_log.payload_hash
      end

      def send_file(payload, log)
        File.open(xml_filepath, "w") { |file| file.write(payload) }
        log.file_path = xml_filepath
        log.sent!
      end

      def last_sent_transmission_log
        @last_sent_transmission_log ||= begin
          TransmissionLog.where(patient: patient, status: :sent).ordered.last || NullObject.instance
        end
      end

      def build_payload(log)
        Payload.new(render_xml_for(patient)).tap do |payload|
          log.payload = payload.to_s
          log.payload_hash = payload.to_md5_hash
        end
      end

      def render_xml_for(patient)
        renderer.render(
          "renalware/api/ukrdc/patients/show",
          locals: { patient: presenter_for(patient) }
        )
      end

      def presenter_for(patient)
        Renalware::UKRDC::PatientPresenter.new(patient, changes_since: changes_since)
      end

      # Note a test might have passed in a mock renderer
      def renderer
        @renderer ||= Renalware::API::UKRDC::PatientsController.renderer
      end

      def xml_filepath
        raise(ArgumentError, "Patient has no ukrdc_external_id") if patient.ukrdc_external_id.blank?
        filename = "#{patient.ukrdc_external_id}.xml"
        File.join(dir, filename)
      end

      class Payload
        pattr_initialize :payload
        delegate :to_s, to: :payload

        def to_md5_hash
          @to_md5_hash ||= Digest::MD5.hexdigest(time_neutral_payload)
        end

        private

        # Remove the time elements from SendingFacility
        # e.g.
        #   <SendingFacility channelName='Renalware' time='2018-02-26T13:18:02+00:00'/>
        # becomes
        #   <SendingFacility channelName='Renalware'/>
        # This allows us to do payload comparisons independent of the time they were sent.
        def time_neutral_payload
          payload
            .gsub(/<Stream>[^<]*<\/Stream>/, "<Stream>removed</Stream>")
            .gsub(/ (time|start|stop)=["'][^'"]*['"]/, '')
        end
      end
    end
  end
end
