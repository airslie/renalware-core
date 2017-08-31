module Renalware

  #log "Adding HD Diaries" do

    class CreateDiary
      attr_reader :unit, :user

      def initialize(unit, user)
        @unit = unit
        @user = user
      end

      def call
        # Build master diary
        master = HD::MasterDiary.find_or_initialize_by(hospital_unit_id: unit.id) do |diary|
          diary.save_by!(user)
        end

        HD::DiurnalPeriodCode.all.each do |code|
          HD::Station.for_unit(unit).each do |station|
            (1..7).each do |day_of_week|
              master.slots.create(
                patient_id: Patient.first.id,
                station: station,
                day_of_week: day_of_week,
                diurnal_period_code: code,
                by: user
              )
            end
          end
        end

        weekly = HD::WeeklyDiary.find_or_initialize_by(
          hospital_unit_id: unit.id,
          master_diary: master,
          year: 2017,
          week_number: Time.zone.today.cweek
        ) do |diary|
          diary.save_by!(user)
        end

        HD::DiurnalPeriodCode.all.each do |code|
          HD::Station.for_unit(unit).each do |station|
            weekly.slots.create(
              patient_id: Patient.first.id,
              station: station,
              day_of_week: (1..7).to_a.sample,
              diurnal_period_code: code,
              by: user)
          end
        end

        # HD::DiurnalPeriodCode.all.each do |code|
        #   period = HD::DiaryPeriod.find_or_initialize_by(diurnal_period_code: code, diary: master) do |per|
        #     per.save_by!(user)
        #   end
        #   if period.slots.empty?
        #     HD::Station.for_unit(unit).each do |station|
        #       (1..7).each do |day_of_week|
        #         period.slots.create(
        #           patient_id: Patient.first.id,
        #           station: station,
        #           day_of_week: day_of_week,
        #           by: user
        #         )
        #       end
        #     end
        #   end
        #end

        # station = HD::Station.find_or_initialize_by(
        #   name: row["name"],
        #   location: row["location"],
        #   hospital_unit_id: unit.id,
        #   position: row["position"]
        # ).save_by!(user)
      end
    end

    CreateDiary.new(Renalware::Hospitals::Unit.first, User.first).call
  #end
end
