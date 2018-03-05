# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Feeds
    module Files
      module PracticeMemberships
        describe ImportCSV do
          let(:uk) { create(:united_kingdom) }

          def with_tmpfile(content)
            tmpfile = Tempfile.new("test_csv")
            tmpfile.write(content)
            tmpfile.rewind
            yield Pathname(tmpfile)
          ensure
            tmpfile.close
            tmpfile.unlink
          end

          context "when there are new memberships" do
            it "imports the GP memberships" do
              pending("PG COPY not avail on CircleCI docker setup yet") if ENV.key?("CI")
              create(:practice, code: "PRAC_1")
              create(:practice, code: "PRAC_2")
              create(:primary_care_physician, code: "GP111111")
              create(:primary_care_physician, code: "GP222222")

              csv_content = <<-CSV.strip_heredoc
                "GP111111","PRAC_1","P","19740401","19910401","0"
                "GP222222","PRAC_2","P","19740401","19910401","0"
              CSV

              with_tmpfile(csv_content) do |tmpfile|
                expect{
                  described_class.new(tmpfile).call
                }
                .to change{ Patients::PracticeMembership.count }.by(2)
              end
            end
          end

          context "when a gp is no longer in a practice" do
            it "they are soft deleted" do
              pending("PG COPY not avail on CircleCI docker setup yet") if ENV.key?("CI")
              practice = create(:practice, code: "PRAC1")
              gp1 = create(:primary_care_physician, code: "GP1")
              gp2 = create(:primary_care_physician, code: "GP2")

              membership1 = create(
                :practice_membership,
                practice: practice,
                primary_care_physician: gp1
              )

              membership2 = create(
                :practice_membership,
                practice: practice,
                primary_care_physician: gp2
              )

              # Because GP2 is omitted from the CSV they should be marked as deleted
              csv_content = <<-CSV.strip_heredoc
                "GP1","PRAC1","P","19740401","19910401","0"
              CSV

              with_tmpfile(csv_content) do |tmpfile|
                expect{
                  described_class.new(tmpfile).call
                }
                .to change{ Patients::PracticeMembership.count }.by(-1)
                .and change{ Patients::PracticeMembership.deleted.count }.by(1)
              end

              expect(membership1.reload).not_to be_deleted
              expect(membership2.reload).to be_deleted
            end
          end
        end
      end
    end
  end
end
