require "csv"

module Renalware
  module Patients
    module ODS
      module DSE
        describe "DSE practice and GP membership scenarios" do
          before { create(:united_kingdom) }

          def csv_row(size, attributes)
            row = Array.new(size, "")
            attributes.each { |index, value| row[index] = value }
            CSV.generate_line(row)
          end

          def practice_row(code, status: "ACTIVE")
            csv_row(27, 0 => code, 1 => "PRACTICE #{code}", 9 => "AA1 1AA", 12 => status)
          end

          def gp_row(code, status: "ACTIVE")
            csv_row(27, 0 => code, 1 => "GP #{code}", 9 => "AA1 1AA", 12 => status)
          end

          def membership_row(gp_code, practice_code, joined_on:, left_on: nil)
            csv_row(
              6,
              0 => gp_code,
              1 => practice_code,
              2 => "P",
              3 => joined_on,
              4 => left_on,
              5 => "1"
            )
          end

          def ods_date(date)
            date.strftime("%Y%m%d")
          end

          def run_sync(practices:, gps:, memberships:)
            contents = {
              "epraccur" => practices.join,
              "egpcur" => gps.join,
              "epracmem" => memberships.join
            }
            downloader = instance_double(Downloader)
            allow(downloader).to receive(:call) do |report_name|
              tempfile_with(contents.fetch(report_name), report_name)
            end
            Synchroniser.new(downloader:, reports: test_reports).call
          end

          def test_reports
            Synchroniser::REPORTS.transform_values { |options| options.merge(minimum_rows: 0) }
          end

          def tempfile_with(content, name)
            Tempfile.new([name, ".csv"]).tap do |file|
              file.write(content)
              file.flush
              file.rewind
            end
          end

          it "moves a GP from Practice B to Practice C" do
            practice_b = create(:practice, code: "A81001")
            practice_c = create(:practice, code: "A81002")
            gp = create(:primary_care_physician, code: "G0100001")
            membership_b = create(
              :practice_membership,
              practice: practice_b,
              primary_care_physician: gp,
              ods_managed: true
            )

            run_sync(
              practices: [practice_row("A81001"), practice_row("A81002")],
              gps: [gp_row("G0100001")],
              memberships: [
                membership_row(
                  "G0100001",
                  "A81001",
                  joined_on: "20200101",
                  left_on: "20250101"
                ),
                membership_row("G0100001", "A81002", joined_on: "20250102")
              ]
            )

            expect(membership_b.reload).to have_attributes(
              active: false,
              left_on: Date.new(2025, 1, 1),
              deleted_at: nil
            )
            expect(gp.practice_memberships.find_by!(practice: practice_c)).to have_attributes(
              active: true,
              joined_on: Date.new(2025, 1, 2),
              left_on: nil
            )
          end

          it "allows a GP to be active at both Practice B and Practice C" do
            run_sync(
              practices: [practice_row("A81001"), practice_row("A81002")],
              gps: [gp_row("G0100001")],
              memberships: [
                membership_row("G0100001", "A81001", joined_on: "20200101"),
                membership_row("G0100001", "A81002", joined_on: "20210101")
              ]
            )

            gp = PrimaryCarePhysician.find_by!(code: "G0100001")
            expect(gp.practice_memberships.where(active: true).count).to eq(2)
            expect(gp.practices.pluck(:code)).to contain_exactly("A81001", "A81002")
          end

          it "removes a retired GP's membership when DSE no longer reports it" do
            practice = create(:practice, code: "A81001")
            gp = create(:primary_care_physician, code: "G0100001")
            membership = create(
              :practice_membership,
              practice:,
              primary_care_physician: gp,
              ods_managed: true
            )

            run_sync(
              practices: [practice_row("A81001")],
              gps: [gp_row("G0100001", status: "RETIRED")],
              memberships: []
            )

            expect(gp.reload).to be_deleted
            expect(membership.reload).to be_deleted
            expect(membership).not_to be_active
          end

          it "marks a permanently closed practice as inactive" do
            practice = create(:practice, code: "A81001", active: true)

            run_sync(
              practices: [practice_row("A81001", status: "INACTIVE")],
              gps: [],
              memberships: []
            )

            expect(practice.reload).not_to be_active
          end

          it "allows an inactive practice to retain an active GP membership" do
            practice = create(:practice, code: "A81001", active: true)
            gp = create(:primary_care_physician, code: "G0100001")
            membership = create(
              :practice_membership,
              practice:,
              primary_care_physician: gp,
              ods_managed: true
            )

            run_sync(
              practices: [practice_row("A81001", status: "INACTIVE")],
              gps: [gp_row("G0100001")],
              memberships: [membership_row("G0100001", "A81001", joined_on: "20200101")]
            )

            expect(practice.reload).not_to be_active
            expect(membership.reload).to have_attributes(active: true, deleted_at: nil)
          end

          it "retains but deactivates a reported membership for a retired GP" do
            practice = create(:practice, code: "A81001")
            gp = create(:primary_care_physician, code: "G0100001")
            membership = create(
              :practice_membership,
              practice:,
              primary_care_physician: gp,
              ods_managed: true
            )

            run_sync(
              practices: [practice_row("A81001")],
              gps: [gp_row("G0100001", status: "RETIRED")],
              memberships: [membership_row("G0100001", "A81001", joined_on: "20200101")]
            )

            expect(gp.reload).to be_deleted
            expect(membership.reload).to have_attributes(active: false, deleted_at: nil)
          end

          it "rolls back when memberships reference an unknown GP or practice" do
            practice = create(:practice, code: "A81001", name: "ORIGINAL PRACTICE")
            gp = create(:primary_care_physician, code: "G0100001", name: "ORIGINAL GP")

            expect {
              run_sync(
                practices: [practice_row("A81001")],
                gps: [gp_row("G0100001")],
                memberships: [
                  membership_row("G0999999", "A81001", joined_on: "20200101"),
                  membership_row("G0100001", "A89999", joined_on: "20200101")
                ]
              )
            }.to raise_error(
              ActiveRecord::StatementInvalid,
              /1 unknown GP code.*G0999999.*1 unknown practice code.*A89999/
            )

            expect(practice.reload.name).to eq("ORIGINAL PRACTICE")
            expect(gp.reload.name).to eq("ORIGINAL GP")
            expect(PracticeMembership.count).to eq(0)
          end

          it "does not change a GP or practice omitted from their master reports" do
            practice = create(:practice, code: "A81001", active: true, ods_managed: true)
            gp = create(:primary_care_physician, code: "G0100001", ods_managed: true)

            run_sync(practices: [], gps: [], memberships: [])

            expect(practice.reload).to have_attributes(active: true, ods_managed: true)
            expect(gp.reload).not_to be_deleted
          end

          it "keeps a membership active before its future leaving date" do
            run_sync(
              practices: [practice_row("A81001")],
              gps: [gp_row("G0100001")],
              memberships: [
                membership_row(
                  "G0100001",
                  "A81001",
                  joined_on: "20200101",
                  left_on: ods_date(6.months.from_now.to_date)
                )
              ]
            )

            expect(PracticeMembership.find_by!(left_on: 6.months.from_now.to_date)).to be_active
          end

          it "keeps a membership active on its leaving date" do
            run_sync(
              practices: [practice_row("A81001")],
              gps: [gp_row("G0100001")],
              memberships: [
                membership_row(
                  "G0100001",
                  "A81001",
                  joined_on: "20200101",
                  left_on: ods_date(Date.current)
                )
              ]
            )

            expect(PracticeMembership.find_by!(left_on: Date.current)).to be_active
          end

          it "deactivates a membership after its leaving date" do
            run_sync(
              practices: [practice_row("A81001")],
              gps: [gp_row("G0100001")],
              memberships: [
                membership_row(
                  "G0100001",
                  "A81001",
                  joined_on: "20200101",
                  left_on: ods_date(Date.yesterday)
                )
              ]
            )

            expect(PracticeMembership.find_by!(left_on: Date.yesterday)).not_to be_active
          end

          it "keeps a retired GP's membership inactive before its future leaving date" do
            run_sync(
              practices: [practice_row("A81001")],
              gps: [gp_row("G0100001", status: "RETIRED")],
              memberships: [
                membership_row(
                  "G0100001",
                  "A81001",
                  joined_on: "20200101",
                  left_on: ods_date(6.months.from_now.to_date)
                )
              ]
            )

            membership = PracticeMembership.find_by!(left_on: 6.months.from_now.to_date)
            expect(membership).not_to be_active
            expect(membership).not_to be_deleted
          end

          it "does not alter the Generic GP or any of its memberships" do
            generic_gp = PrimaryCarePhysician.generic
            practice_a = create(:practice, code: "A81001")
            practice_b = create(:practice, code: "A81002")
            default_membership = create(
              :practice_membership,
              practice: practice_a,
              primary_care_physician: generic_gp,
              default_gp: true,
              joined_on: Date.new(2020, 1, 1)
            )
            non_default_membership = create(
              :practice_membership,
              practice: practice_b,
              primary_care_physician: generic_gp,
              ods_managed: true,
              joined_on: Date.new(2021, 1, 1)
            )
            gp_attributes = generic_gp.reload.attributes
            default_membership_attributes = default_membership.reload.attributes
            non_default_membership_attributes = non_default_membership.reload.attributes

            run_sync(
              practices: [practice_row("A81001"), practice_row("A81002")],
              gps: [gp_row(PrimaryCarePhysician::GENERIC_CODE, status: "RETIRED")],
              memberships: [
                membership_row(
                  PrimaryCarePhysician::GENERIC_CODE,
                  "A81001",
                  joined_on: "20250101",
                  left_on: "20250102"
                )
              ]
            )

            expect(generic_gp.reload.attributes).to eq(gp_attributes)
            expect(default_membership.reload.attributes).to eq(default_membership_attributes)
            expect(non_default_membership.reload.attributes).to eq(
              non_default_membership_attributes
            )
          end
        end
      end
    end
  end
end
