begin
  db_settings = YAML.load_file('config/database.yml')["test"]
rescue
  puts "Couldn't find config/database.yml. Do you need to copy it from config/database.yml.example?"
end

# Update the renalwareconn.php for this environment
ENV['php_db_host'] = db_settings["host"]
ENV['php_db_user'] = db_settings["username"]
ENV['php_db_password'] = db_settings["password"]
ENV['php_db'] = db_settings["database"]

client = Mysql2::Client.new(:host => db_settings["host"], :username => db_settings["username"])

Before do
  client.query("CREATE DATABASE IF NOT EXISTS #{db_settings["database"]}")

  # Load legacy schema
  `cat db/schema.sql | mysql #{db_settings["database"]} -u #{db_settings["username"]}`

  $client = Mysql2::Client.new(:host => "localhost", :username => db_settings["username"],
    :database => db_settings["database"])
end

at_exit do
  client.query("DROP DATABASE #{db_settings["database"]}")
  client.close
end