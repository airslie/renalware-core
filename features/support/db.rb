# Wipe the test database before after the tests have run
DB_NAME = 'cuke_php_test'

client = Mysql2::Client.new(:host => "localhost", :username => ENV["USER"])

# Load legacy schema
`cat db/schema.sql | mysql #{DB_NAME} -u #{ENV['USER']}`

Before do
  client.query("CREATE DATABASE IF NOT EXISTS #{DB_NAME}")
  $client = Mysql2::Client.new(:host => "localhost", :username => ENV["USER"],
    :database => DB_NAME)
end

at_exit do
  client.query("DROP DATABASE #{DB_NAME}")
  client.close
end