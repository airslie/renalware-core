def default_path
  Rails.root.join('db','seeds','default')
end

log "--------------------Seeding data from #{default_path}--------------------"

Dir.glob(File.join(default_path, '**/*.{rb}')).sort.each do |file|
  require file
end

