module Renalware
  log "Adding HD Schedule Definitions" do
    user = User.last
    file_path = File.join(File.dirname(__FILE__), "schedule_definitions.yml")
    definitions = YAML.load_file(file_path)
    definitions.each do |_key, definition|
      definition.symbolize_keys!

      period = HD::DiurnalPeriodCode.find_or_create_by!(code: definition[:diurnal_period_code])

      HD::ScheduleDefinition.find_or_create_by!(
        diurnal_period: period,
        days: definition[:days]
      )
    end
  end
end
