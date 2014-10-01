Given(/^the legacy database data "(.*?)"$/) do |fixture_ddl|
  # TODO make this nicer to work with?
  `cat test/db/#{fixture_ddl} | mysql #{DB_NAME} -u #{ENV['USER']}`
end
