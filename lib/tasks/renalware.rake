# frozen_string_literal: true

namespace :renalware do
  desc "Install package.json dependencies with yarn for the renalware-core engine - "\
       "without this <path to installed gem>/renalware-core/node_modules is not populated "\
       "and assets:precompile in the host app will not work."
  task :yarn_install do
    puts "Installing renalware-core/package.json dependencies with yarn"
    Dir.chdir(File.join(__dir__, "../..")) do
      system "yarn install --no-progress --production"
    end
  end
end

if Rake::Task.task_defined?("yarn:install")
  Rake::Task["yarn:install"].enhance(["renalware:yarn_install"])
else
  Rake::Task.define_task("yarn:install" => "renalware:yarn_install")
end
