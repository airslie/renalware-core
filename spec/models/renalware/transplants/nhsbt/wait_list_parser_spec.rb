require "rails_helper"

module Renalware
  module Transplants
    module NHSBT
      describe WaitListParser do
        def parse_csv(csv)
          Tempfile.create(["nhsbt_wait_list", ".csv"]) do |file|
            file.write(csv)
            file.rewind
            described_class.new(file.path).call
          end
        end

        it "parses two CSV sections separated by a blank row", :aggregate_failures do
          rows = parse_csv(<<~CSV)
            RECIP ID,NAME,DATE OF BIRTH,KIDNEY STATUS,KIDNEY STATUS DATE,PANCREAS STATUS,TISSUE TYPE,SENSI EVAL DATE,CRF,MATCH SCORE,MATCH POINTS,KIDNEY WAITING TIME (days),PANCREAS WAITING TIME (days)
            1234,"SMITH, SAM",25/04/1977,ACTIVE - ROUTINE,12/01/2024,NOT REQUIRED,A2 B15 B75,25/07/2023,50,93,8,776,

            RECIP ID,NAME,DATE OF BIRTH,KIDNEY STATUS,KIDNEY STATUS DATE,PANCREAS STATUS,TISSUE TYPE,SENSI EVAL DATE,CRF,MATCH SCORE,MATCH POINTS,KIDNEY WAITING TIME (days),PANCREAS WAITING TIME (days)
            456,"JONES, JOHN",26/04/1977,SUSPENDED,13/01/2024,NOT REQUIRED,A1 B8 B44,26/07/2023,20,88,7,100,20
          CSV

          expect(rows.map(&:recip_id)).to eq(%w(1234 456))
          expect(rows.first.date_of_birth).to eq(Date.parse("1977-04-25"))
          expect(rows.first.kidney_status).to eq("ACTIVE - ROUTINE")
          expect(rows.first.kidney_status_date).to eq(Date.parse("2024-01-12"))
          expect(rows.first.tissue_type).to eq("A2 B15 B75")
          expect(rows.first.match_score).to eq("93")
          expect(rows.first.match_points).to eq("8")
          expect(rows.first.crf).to eq("50")
          expect(rows.first.sensi_eval_date).to eq(Date.parse("2023-07-25"))
          expect(rows.first.kidney_waiting_time_days).to eq("776")
          expect(rows.first.pancreas_waiting_time_days).to be_nil
        end

        it "raises an error when a date is not in UK dd/mm/yyyy format" do
          expect {
            parse_csv(<<~CSV)
              RECIP ID,DATE OF BIRTH,KIDNEY STATUS,KIDNEY STATUS DATE,TISSUE TYPE,SENSI EVAL DATE,CRF,MATCH SCORE,MATCH POINTS,KIDNEY WAITING TIME (days),PANCREAS WAITING TIME (days)
              1234,04/25/1977,ACTIVE - ROUTINE,12/01/2024,A2 B15 B75,25/07/2023,50,93,8,776,12
            CSV
          }.to raise_error(
            described_class::InvalidCSV,
            "Invalid UK date '04/25/1977' on line 2; expected dd/mm/yyyy"
          )
        end
      end
    end
  end
end
