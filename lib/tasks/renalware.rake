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

def enhance_assets_precompile_with_engine_yarn_install
  Rake::Task["assets:precompile"].enhance(["renalware:yarn_install"])
end

# When a host app runs rake assets:precompile, hook into this and enhance the
# task so it runs yarn install for (and relative to) the engine, wherever it is installed.
# Without that, assets:precompile will fail because the engine references various js and css files
# in ./node_modules, and these are not included in the source, but need to be installed with yarn
# at deploy time.
if Rake::Task.task_defined?("assets:precompile")
  enhance_assets_precompile_with_engine_yarn_install
end
