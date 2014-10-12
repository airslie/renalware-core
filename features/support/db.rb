client = Mysql2::Client.new(:host => "localhost", :username => "renalware", :password => "password")

Before do
  client.query("CREATE DATABASE IF NOT EXISTS renalware_test")

  # Load legacy schema
  `cat db/schema.sql | mysql renalware_test -u renalware --password=password`

  $client = Mysql2::Client.new(:host => "localhost", :username => "renalware",
    :database => "renalware_test", :password => "password")
end

at_exit do
  client.query("DROP DATABASE renalware_test")
  client.close
end