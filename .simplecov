require "codeclimate-test-reporter"
SimpleCov.start "rails" do
  use_merging true
  merge_timeout 1200 # 20 minutes
end
