$client = Mysql2::Client.new(:host => "localhost", :username => "renalware",
  :database => "renalware_test", :password => "password", :init_command => "SET UNIQUE_CHECKS = 0")

at_exit do
  reset_database
  $client.close
end

Before do
  $client.query 'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED'
  $client.query 'START TRANSACTION'
end

After do
  $client.query 'ROLLBACK'
end

def reset_database
  $client.query("DROP DATABASE renalware_test")
  $client.query("CREATE DATABASE IF NOT EXISTS renalware_test")

  # Load legacy schema
  `cat db/schema_v1.sql | mysql renalware_test -u renalware --password=password`
end