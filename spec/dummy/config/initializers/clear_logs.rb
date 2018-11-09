# frozen_string_literal: true

# Keep development logs small
if Rails.env.development?
  MAX_LOG_SIZE = 10.megabytes
  logs = Rails.root.join("log", "*.log")
  if Dir[logs].any? { |log| File.size?(log).to_i > MAX_LOG_SIZE }
    $stdout.puts "Running rails log:clear"
    `rails log:clear`
  end
end
