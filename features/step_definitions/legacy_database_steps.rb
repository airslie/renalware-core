Given(/^the legacy database data "(.*?)"$/) do |fixture_ddl|
  # TODO make this nicer to work with?
  `cat test/db/#{fixture_ddl} | mysql cuke_php_test -u daniel`
end
