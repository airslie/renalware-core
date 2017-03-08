# Setting a command name here is to solve the issue where when we run
# `bundle exec codeclimate-test-reporter` from e.g. circleci.yml, (to send our merged test coverage
# results to code climate) it actually loads this file and tries to run more tests!
# And as we had not specified a command name, it uses
# 'Unknown Framework', resulting in the following error:
#  > SimpleCov failed to recognize the test framework and/or suite used.
#  > Please specify manually using SimpleCov.command_name 'Unit Tests'.
# So setting command_name here gets around that error, though this also adds lot of empty data
# to coverage./resultset.json under the 'cruft heading, but fortunately does not affect the results.
# I can't find a solution to this problem at the moment (which usually suggests we are doing
# something daft!) but this is one to figure out at a later time.

unless caller.join("") =~ /codeclimate-test-reporter/
  SimpleCov.start "rails" do
    p "SimpleCov.start"
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
