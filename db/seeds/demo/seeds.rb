def demo_path
  Rails.root.join('db','seeds','demo')
end

log "--------------------Seeding data from #{demo_path}--------------------"
Dir.glob(File.join(demo_path, '**/*.{rb}')).sort.each do |file|
  require file
end
