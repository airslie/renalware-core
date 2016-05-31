def test_path
  Rails.root.join('db','seeds','test')
end

log "--------------------Seeding data from #{test_path}--------------------"

Dir.glob(File.join(test_path, '**/*.{rb}')).sort.each do |file|
  require file
end
