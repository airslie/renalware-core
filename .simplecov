unless caller.join("") =~ /codeclimate-test-reporter/
  SimpleCov.start "rails" do

    # save to CircleCI's artifacts directory if we're on CircleCI
    #if ENV['CIRCLE_ARTIFACTS']
    #  dir = File.join(ENV['CIRCLE_ARTIFACTS'], "coverage")
    #  coverage_dir(dir)
    #end

    use_merging true
    merge_timeout 1200 # 20 minutes
    # any custom configs like groups and filters can be here at a central place
    add_filter "/spec/models/concerns"
    add_filter "/features"
    add_filter "/spec/support"
  end
end
