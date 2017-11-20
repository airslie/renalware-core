require "rails_helper"
require "renalware/week_period"

module Renalware::HD
  describe ArchiveYesterdaysSlotsJob do
    subject(:job) { described_class.new }

    let(:user){ create(:user) }
    let(:patient){ create(:hd_patient) }
    let(:unit) { create(:hospital_unit) }
    let(:station) { create(:hd_station, hospital_unit_id: unit.id, by: user) }
    let(:diurnal_period_code) { create(:hd_diurnal_period_code) }
    let(:master_diary) do
      create(
        :hd_master_diary,
        hospital_unit_id: unit.id,
        by: user
      )
    end

    def create_weekly_diary(week_period:)
      create(
        :hd_weekly_diary,
        master_diary: master_diary,
        hospital_unit_id: unit.id,
        week_number: week_period.week_number,
        year: week_period.year,
        by: user
      )
    end

    def create_slot(diary:, day_of_week:)
      create(:hd_diary_slot,
              diary: diary,
              patient: patient,
              station: station,
              day_of_week: day_of_week,
              diurnal_period_code_id: diurnal_period_code.id,
              by: user)
    end

    describe "#perform" do
      it "defaults the :up_until parameter to the end of yesterday" do
        job.perform
        expect(job.up_until).to eq((Time.zone.today - 1.day))
      end

      context "when there are no old slots" do
        it "does nothing" do
          job.perform
        end
      end

      context "when there is an un-archived slot yesterday" do
        it "it archives it" do
          diary = nil
          # Travel to an arbitrary yesterday
          # Its week 5 and the day_of_week is 2 (Tuesday)
          travel_to Date.new(2017, 01, 31) do
            week_period = Renalware::WeekPeriod.from_date(Time.zone.today)
            day_of_week = Time.zone.today.cwday

            expect(week_period.week_number).to eq(5)
            expect(day_of_week).to eq(2)

            diary = create_weekly_diary(week_period: week_period)
            create_slot(diary: diary, day_of_week: day_of_week)

          end

          # now travel to the day after (Wednesday)
          # we'll create another slot here which should not be archived
          travel_to Date.new(2017, 02, 01) do
            week_period = Renalware::WeekPeriod.from_date(Time.zone.today)
            todays_day_of_week = Time.zone.today.cwday

            expect(week_period.week_number).to eq(5)
            expect(todays_day_of_week).to eq(3)

            slot_that_should_not_be_archived = create_slot(
              diary: diary,
              day_of_week: todays_day_of_week
            )

            expect(Renalware::HD::DiarySlot.count).to eq(2)
            expect(Renalware::HD::DiarySlot.archived.count).to eq(0)
            expect(Renalware::HD::DiarySlot.unarchived.count).to eq(2)

            # Running the job with no arguments will try and archive yesterday slot
            job.perform

            expect(Renalware::HD::DiarySlot.count).to eq(2)
            expect(Renalware::HD::DiarySlot.archived.count).to eq(1)
            expect(Renalware::HD::DiarySlot.unarchived.count).to eq(1)
            expect(slot_that_should_not_be_archived.reload.archived).to be_falsy
          end
        end
      end
    end
  end
end
