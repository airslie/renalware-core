# frozen_string_literal: true

# On asset precompilation the tailwindcss purges unused classes so it only outputs a css file with
# the utility classes we have actually used in the app. You can set the paths to search
# in config/tailwind.config.js. However we need to tell the tailwindcss executable to
# include in the purge any view files etc in downstream rails engines. We can't inject the
# path to these folders in the usual config/tailwind.config.js very easily, so here
# we take the approach (based on https://github.com/rails/tailwindcss-rails/issues/108)
# of re-writing the config/tailwind.config.js file using ruby so we can resolve the
# correct path to the the engine's root, and so include the correct physical paths in the
# js file. This way tailwindcss will search these paths for css classes when purging unused
# classes.

# Used by dumy app only

namespace :tailwind do
  desc "Generate a component-aware config/tailwind.config.js file"
  task :generate_config do
    roots = [
      Renalware::Engine.root,
      "."
    ]
    paths = roots.map do |root|
      [
        "'#{root}/app/helpers/**/*.rb'",
        "'#{root}/app/views/**/*.{erb,haml,html,slim}'",
        "'#{root}/app/components/**/*.{erb,haml,html,slim}'",
        "'#{root}/app/assets/javascripts/**/*'",
        "'#{root}/app/javascript/**/*'"
      ]
    end.flatten

    File.write(Rails.root.join("config/tailwind.config.js"), <<~JS)
      const defaultTheme = require('tailwindcss/defaultTheme')

      module.exports = {
        content: [
          #{paths.join(",\n    ")},
        ],
        theme: {
          extend: {
            fontFamily: {
              sans: ['Inter var', ...defaultTheme.fontFamily.sans],
            },
          },
        },
        plugins: [
          require('@tailwindcss/forms'),
          require('@tailwindcss/aspect-ratio'),
          require('@tailwindcss/typography'),
        ]
      }
    JS
  end
end

Rake::Task["app:tailwindcss:build"].enhance(["app:tailwind:generate_config"])
Rake::Task["app:tailwindcss:watch"].enhance(["app:tailwind:generate_config"])
