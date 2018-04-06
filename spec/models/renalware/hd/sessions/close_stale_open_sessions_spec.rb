# frozen_string_literal: true

require "rails_helper"

module Renalware
  module HD
    describe Sessions::CloseStaleOpenSessions do
      subject(:service) { described_class }

      let(:patient) { create(:hd_patient) }
      let(:performed_before) { 3.days.ago }
      let(:system_user) { create(:user, username: SystemUser.username) }
      let(:hospital_unit) { create(:hospital_unit) }
      let(:options) do
        {
          patient: patient,
          by: system_user,
          signed_on_by: system_user,
          hospital_unit: hospital_unit,
          performed_on: 1.day.ago
        }
      end

      before do
        system_user # creates system user
      end

      context "when there are no sessions" do
        it "does nothing" do
          expect { service.call }.to change(Session::Closed, :count).by(0)
        end
      end

      context "when there are no open sessions" do
        it "does nothing" do
          create(:hd_closed_session, **options)
          expect { service.call }.to change(Session::Closed, :count).by(0)
        end
      end

      context "when there is an open session with a signed_off_by that is not yet old enough" do
        it "does nothing" do
          create(
            :hd_open_session,
            **options.merge(
              signed_off_by: system_user,
              performed_on: 1.day.ago
            )
          )

          expect {
            service.call(performed_before: performed_before)
          }.to change(Session::Closed, :count).by(0)
        end
      end

      context "when there is an open session that is stale" do
        context "when the session has a signed_off_by" do
          context "when the session is valid" do
            it "closes the session" do
              session = create(
                :hd_open_session,
                **options.merge(
                  signed_off_by: system_user,
                  performed_on: 4.days.ago,
                  end_time: "23:59",
                  document: nil
                )
              )
              session.update!(document: build(:hd_session_document).marshal_dump)
              session = session.reload

              results = nil
              expect {
                results = service.call(performed_before: performed_before)
              }.to change(Session::Closed, :count).by(1)
               .and change(Session::Open, :count).by(-1)

              expect(Session::Closed.where(id: session.id).exists?).to eq(true)
              expect(results.closed_ids).to eq([session.id])
              expect(results.unclosed_ids).to be_empty
            end
          end

          context "when the session is invalid" do
            it "logs the error" do
              session = create(
                :hd_open_session,
                **options.merge(
                  signed_off_by: system_user,
                  performed_on: 4.days.ago,
                  end_time: "23:59",
                  document: nil
                )
              )

              results = nil
              expect {
                results = service.call(performed_before: performed_before)
              }.to change(Session::Closed, :count).by(0)

              expect(results.closed_ids).to be_empty
              expect(results.unclosed_ids).to eq [session.id]
            end
          end
        end
      end
    end
  end
end
