# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe UKRDC::CreatePatientXMLFile do
    let(:user) { create(:user) }
    let(:request_uuid) { SecureRandom.uuid }
    let(:xml) {
      # This the XML our mock renderer will always render!
      <<-XML
      <xml>
        <SendingFacility channelName='Renalware' time='2018-02-26T13:18:02+00:00'/>
        <AnotherElement some_attribute=''></AnotherElement>
        <LabOrders start="2018-02-23T00:00:00+00:00" stop="2018-02-26T18:35:28+00:00">
        </LabOrders>
        <Observations start="2018-02-23T00:00:00+00:00" stop="2018-02-26T18:35:28+00:00">
        </Observations>
      </xml>
      XML
    }
    let(:xml_with_sending_facility_time_removed) {
      <<-XML
      <xml>
        <SendingFacility channelName='Renalware'/>
        <AnotherElement some_attribute=''></AnotherElement>
        <LabOrders>
        </LabOrders>
        <Observations>
        </Observations>
      </xml>
      XML
    }
    let(:renderer) { double(:renderer, render: xml) }
    let(:xml_md5_hash) { Digest::MD5.hexdigest(xml_with_sending_facility_time_removed) }
    let(:patient) do
      create(
        :patient,
        ukrdc_external_id: SecureRandom.uuid,
        sent_to_ukrdc_at: 1.week.ago
      )
    end

    context "when the patient has never been sent to the UKRDC before" do
      it "'sends' a new XML file and updates the log entry correctly" do
        patient.update_by(user, sent_to_ukrdc_at: nil)

        Dir.mktmpdir(nil, Rails.root.join("tmp").to_s) do |dir|
          described_class.new(
            request_uuid: request_uuid,
            renderer: renderer,
            patient: patient,
            batch_number: 1,
            dir: dir,
            changes_since: "2017-01-01" # required if sent_to_ukrdc_at is nil!
          ).call

          log = UKRDC::TransmissionLog.where(patient: patient).last
          expect(log.error).to be_nil
          expect(log.payload).to eq(xml)
          expect(log.payload_hash).to eq(xml_md5_hash)
          expect(log.file_path).to eq(File.join(dir, "RJZ_1_#{patient.nhs_number}.xml"))
          expect(File.read(log.file_path)).to eq(xml) # Check the correct content was written
        end
      end
    end

    context "when the patient has previously been sent to the UKRDC but now something about "\
            " has cause the XML content to differ" do
      let(:prevous_transmission_log) {
        UKRDC::TransmissionLog.create!(
          request_uuid: request_uuid,
          patient: patient,
          status: :sent,
          sent_at: 1.week.ago,
          payload: "<xml>out of date</xml>",
          payload_hash: Digest::MD5.hexdigest("<xml>out of date</xml>")
        )
      }

      it "'sends' a new XML file and updates the log entry correctly" do
        prevous_transmission_log

        Dir.mktmpdir(nil, Rails.root.join("tmp").to_s) do |dir|
          described_class.new(
            request_uuid: request_uuid,
            renderer: renderer,
            patient: patient,
            batch_number: 1,
            dir: dir
          ).call

          log = UKRDC::TransmissionLog.where(patient: patient).last
          expect(log.error).to be_nil
          expect(log.payload).to eq(xml)
          expect(log.payload_hash).to eq(xml_md5_hash)
          expect(log.file_path).to eq(File.join(dir, "RJZ_1_#{patient.nhs_number}.xml"))
          expect(File.read(log.file_path)).to eq(xml) # Check the correct content was written
        end
      end
    end

    context "when the patient has previously been sent to the UKRDC but *nothing* about has "\
            " changes so the payload_hash is the same" do

      let(:prevous_transmission_log) {
        UKRDC::TransmissionLog.create!(
          request_uuid: request_uuid,
          patient: patient,
          status: :sent,
          sent_at: 1.week.ago,
          payload: xml,
          payload_hash: xml_md5_hash
        )
      }

      it "does *not* send a new XML file but updates the log entry as unsent" do
        prevous_transmission_log

        Dir.mktmpdir(nil, Rails.root.join("tmp").to_s) do |dir|
          described_class.new(
            request_uuid: request_uuid,
            renderer: renderer,
            patient: patient,
            batch_number: 1,
            dir: dir
          ).call

          log = UKRDC::TransmissionLog.where(patient: patient).last
          expect(log.error).to be_nil
          expect(log.payload).to eq(xml)
          expect(log.payload_hash).to eq(xml_md5_hash)
          expect(log.file_path).to be_nil
        end
      end
    end
  end
end
