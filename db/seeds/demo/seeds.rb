def demo_path
  Rails.root.join('db','seeds','demo')
end

Rake::Task['users:add_super_admin'].invoke if Rails.env.development?
Rake::Task['users:add_demo_admin_user'].invoke if Rails.env.development?

log "--------------------Seeding data from #{demo_path}--------------------"
Dir.glob(File.join(demo_path, '**/*.{rb}')).sort.each do |file|
  require file
end
