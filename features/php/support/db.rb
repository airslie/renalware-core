def rails_db_config
  @config ||= YAML::load_file("config/database.yml")["php_test"]
end

def mysql_client
  @mysql_client ||= Mysql2::Client.new(rails_db_config)
end

at_exit do
  reset_database
  mysql_client.close
end

Before do
  mysql_client.query 'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED'
  mysql_client.query 'START TRANSACTION'
end

After do
  mysql_client.query 'ROLLBACK'
end

def reset_database
  # $client.query("DROP DATABASE renalware_test")
  # $client.query("CREATE DATABASE IF NOT EXISTS renalware_test")

  # Load legacy schema
  `cat db/schema_v1.sql | mysql #{rails_db_config['database']} -u #{rails_db_config['username']} --password=#{rails_db_config['password']}`
end