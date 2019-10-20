# frozen_string_literal: true

def ensure_log_goes_to_stdout
  old_logger = Webpacker.logger
  Webpacker.logger = ActiveSupport::Logger.new(STDOUT)
  yield
ensure
  Webpacker.logger = old_logger
end

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

  desc "Cleans the Webpack output folder (public/renalware-core-packs)"
  task :clean_webpack_output_folder do
    puts "Destroying packs output folder ..."
    Dir.chdir(File.join(__dir__, "..", "..")) do
      # TODO : Load packs output from config/webpacker.yml
      system "rm -rf public/renalware-core-packs"
    end
  end

  # I have found that it is necessary to force remove public/renalware-core-packs with the
  # clean_webpack_output_folder task above before compiling, otherwise webpack does not
  # always find changes in js/controllers/*.js. I think this is safe to do in a capistrano deploy
  # because the symlink to public is only applied after a successful execution of (among other
  # things) assets:precompile.
  desc "Compile JavaScript packs using webpack for production with digests"
  task webpacker_compile: %i(clean_webpack_output_folder yarn_install environment) do
    puts "Compiling renalware-core packs with webpack.."
    if Rails.env.development? || Rails.env.test?
      compile_webpacker_output
    else
      temporarily_point_webpacker_config_public_root_path_to_rails_app_root do
        compile_webpacker_output
      end
    end
  end
end

def compile_webpacker_output
  Webpacker.with_node_env("production") do
    ensure_log_goes_to_stdout do
      if Renalware.webpacker.commands.compile
        # Successful compilation!
      else
        # Failed compilation
        exit!
      end
    end
  end
end

# This is something of a hack to get webpacker to compile the renalware-core-packs in the
# host Rails app's public folder. We change out config/webpacker.yml to point to the host app's
# public path, do the compile, then revert out change.
# The downside of this approach is that if running staging or production env locally without
# nginx to find and serve public/renalware-core-packs, the pack files will not be found by the host
# because the Rack::Static middleware we setup in engine.rb will not find them.
# An alternative is for us to do the compile inside the engine and then cp -R or rsync (better
# if we are symlinking renawlare-core-packs to shared in deploy.rb) the
# folder into the host's public app where it can be served by nginx (if configured).
# This has the advantage that the same files are available in the engine's public folder (so they
# can be servered by Rack::Static - see engine.rb) and also in the host apps public folder
# where nginx can server them if we are in a real 'environment'
def temporarily_point_webpacker_config_public_root_path_to_rails_app_root
  engine_config_folder = Renalware::Engine.root.join("config")
  find = "public_root_path: .*$"
  replace = "public_root_path: #{Rails.root.join('public')}"

  # This changes the contents of file, creating a backup in webpacker.yml.bak
  `ruby -pi.bak -e "gsub(/#{find}/, '#{replace}')" #{engine_config_folder}/webpacker.yml`

  yield if block_given?
ensure
  # Ensure that we always restore the backup webpacker.yml
  FileUtils.mv(
    engine_config_folder.join("webpacker.yml.bak"),
    engine_config_folder.join("webpacker.yml")
  )
end

def enhance_assets_precompile_with_renalware_webpacker_compile
  Rake::Task["assets:precompile"].enhance(["renalware:webpacker_compile"])
end

# When a host app runs rake assets:precompile, hook into this and enhance the
# task so it runs webpacker install for (and relative to) the engine, wherever it is installed.
# Without that, assets:precompile will fail because the engine references various js and css files
# in ./node_modules, and these are not included in the source, but need to be installed with yarn
# at deploy time.
#
# Note that when runnning in the engine in development, we need to set the ENV
# var WEBPACKER_PRECOMPILE=no (e.g. in ./.env) otherwise wepacker will enhance the
# 'assets:precompile' task with 'webpacker:compile' task, and the latter task does not exist
# in out context (for us its called app:webpacker:compile).
# A possible downside of this is that webpacker compilation in the dummy app, if ever required, may
# not work, I'm not sure.
if Rake::Task.task_defined?("assets:precompile")
  enhance_assets_precompile_with_renalware_webpacker_compile
else
  Rake::Task.define_task("assets:precompile" => "renalware:webpacker:compile")
end
