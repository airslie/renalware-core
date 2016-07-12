# System seeds must exist or the application will malfunction if the expected records
# with the specified system codes are missing. i.e. the application code does explicit
# look up for records based on the system code.
#
def system_path
  Rails.root.join('db','seeds','system')
end

log "--------------------Seeding data from #{system_path}--------------------"

Dir.glob(File.join(system_path, "**/*.{rb}")).sort.each do |file|
  require file
end

