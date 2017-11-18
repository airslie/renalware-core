if defined?(SimpleCov)
  require "codeclimate-test-reporter"

  warn "Configuring SimpleCov"
  SimpleCov.start "rails" do
    use_merging true
    merge_timeout 1200 # 20 minutes

    add_filter "/spec/models/concerns"
    add_filter "/features"
    add_filter "/spec/support"
  end
end
