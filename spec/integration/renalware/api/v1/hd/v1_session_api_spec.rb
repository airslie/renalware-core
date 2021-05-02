# frozen_string_literal: true

require "rails_helper"

# What does the api look like?
# We need to
# - test if a session exists (? or do we upsert)
# - create a session
# - update a session
# - list them? no

# TODO: move validation error checks to form object spec and here
# just check that the errors are returned in the json?

describe "V1 HD Session API", type: :system do
  let(:auser) { create(:user, username: "aaaaa", authentication_token: "wWsSmmHywhYMWPM6e9ib") }
  let(:provider) { Renalware::HD::Provider.create!(name: "Nikkiso") }
  let(:hospital_unit) { create(:hospital_unit, unit_code: "XXX") }
  let(:patient) { create(:hd_patient, local_patient_id_2: "MRN123") }
  let(:adate) { "2021-03-01" }

  def url_with_credentials(user: auser, mrn: patient.local_patient_id_2, date: adate)
    renalware.api_v1_hd_session_path(
      mrn: mrn,
      date: date,
      username: user&.username,
      token: user&.authentication_token
    )
  end

  # This json when PUTted should always return success
  def valid_session_json
    {
      provider_name: provider.name,
      mrn: patient.local_patient_id_2,
      started_at: "2021-03-01 10:22:22",
      ended_at: "2021-03-01 13:01:01",
      machine_number: "123",
      machine_ip_address: "",
      hospital_unit_code: hospital_unit.unit_code,
      state: :open # or closed
    }
  end

  def response_errors
    JSON.parse(response.body)["error"]
  end

  it "denies access if no auth token passed" do
    put url_with_credentials(user: nil)

    expect(response).to be_unauthorized
  end

  context "when json payload is valid" do
    it "returns 200 OK with json containing the session id" do
      url = url_with_credentials

      put url, params: { session: valid_session_json }

      expect(response).to be_ok
      expect(JSON.parse(response.body)).to eq(
        {
          "errors" => [],
          "session_id" => patient.hd_sessions.last.id
        }
      )
    end

    it "creates a session associated with the patient and provider" do
      url = url_with_credentials

      put url, params: { session: valid_session_json }

      expect(response).to be_ok
      session_id = JSON.parse(response.body)["session_id"]
      session = Renalware::HD::Session.find(session_id)

      expect(session).to have_attributes(
        patient: patient,
        provider: provider,
        hospital_unit: hospital_unit,
        performed_on: Date.parse(valid_session_json[:started_at]),
        machine_ip_address: valid_session_json[:machine_ip_address],
        signed_on_by: auser,
        created_by: auser
      )

      # NOTE: performed_on + start_time + end_time is moving to
      # started_at and stopped_at in a pending PR
      expect(session.start_time.strftime("%H:%M")).to eq(
        Time.zone.parse(valid_session_json[:started_at]).strftime("%H:%M")
      )

      expect(session.end_time.strftime("%H:%M")).to eq(
        Time.zone.parse(valid_session_json[:ended_at]).strftime("%H:%M")
      )

      expect(session.document.info).to have_attributes(
        machine_no: valid_session_json[:machine_number]
      )
    end
  end

  describe "validating presence of items in payload json" do
    {
      provider_name: "Provider name can't be blank",
      mrn: "Mrn can't be blank",
      started_at: "Started at can't be blank",
      machine_number: "Machine number can't be blank",
      hospital_unit_code: "Hospital unit code can't be blank"
    }.each do |key, error|
      context "when #{key} is missing" do
        it "returns an error" do
          url = url_with_credentials
          params = valid_session_json.update(key => "")

          put url, params: { session: params }

          expect(response).to be_bad_request
          expect(response_errors).to include(error)
        end
      end
    end

    context "when the provider does not exist" do
      it "returns an error" do
        url = url_with_credentials
        params = valid_session_json.update(provider_name: "bad-name")

        put url, params: { session: params }

        expect(response).to be_bad_request
        expect(response_errors).to include("Provider not found")
      end
    end
  end

  describe "validating dates" do
    context "when ended_at <= started_at" do
      it "returns an error" do
        params = valid_session_json.update(
          started_at: "2013-01-01 11:00:00",
          ended_at: "2013-01-01 10:00:00"
        )

        put url_with_credentials, params: { session: params }

        expect(response).to be_bad_request
        expect(response_errors).to include("Ended at must be after 2013-01-01 11:00:00")
      end
    end

    context "when ended_at is >= 10 hours after started_at" do
      it "returns an error" do
        params = valid_session_json.update(
          started_at: "2013-01-01 01:00:00",
          ended_at: "2013-01-01 11:30:00"
        )

        put url_with_credentials, params: { session: params }

        expect(response).to be_bad_request
        expect(response_errors).to include("Ended at must be before 2013-01-01 11:00:00")
      end
    end

    context "when started_on is not a datetime" do
      it "returns an error" do
        params = valid_session_json.update(started_at: "bad-date")

        put url_with_credentials, params: { session: params }

        expect(response).to be_bad_request
        expect(response_errors).to include("Started at is not a valid datetime")
      end
    end
  end

  describe "when hospital unit code not found" do
    it "returns an error" do
      params = valid_session_json.update(hospital_unit_code: "bad-unit-code")

      put url_with_credentials, params: { session: params }

      expect(response).to be_bad_request
      expect(response_errors).to include("Hospital unit not found")
    end
  end

  describe "when patient not found" do
    it "returns an error" do
      put url_with_credentials(mrn: "bad-mrn"), params: { session: valid_session_json }

      expect(response).to be_bad_request
      expect(response_errors).to include("Patient not found")
    end
  end

  describe "when the session already exists for the current mrn and date" do
    it "updates the existing session" do
      session = create(:hd_session, patient: patient, performed_on: adate, start_time: "01:00")

      put url_with_credentials,
          params: { session: valid_session_json.update(started_at: "2021-03-01 22:22:00") }

      expect(response).to be_ok
      expect(JSON.parse(response.body)).to eq(
        {
          "errors" => [],
          "session_id" => session.id
        }
      )

      session.reload
      expect(session.start_time.strftime("%H:%M")).to eq("22:22")
    end
  end
end
