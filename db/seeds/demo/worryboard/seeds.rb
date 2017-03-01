module Renalware

  # Set the current DB connection
  connection = ActiveRecord::Base.connection();

  log "SQL INSERT 3 sample Worryboard patients" do

  # Execute a sql statement
    connection.execute("INSERT INTO patient_worries (id, patient_id,
    updated_by_id, created_by_id, created_at, updated_at) VALUES
    (1, 1, 9, 9, '2017-03-01 15:21:45.242479', '2017-03-01 15:21:45.242479'),
    (2, 2, 9, 9, '2017-03-01 15:22:00.922088', '2017-03-01 15:22:00.922088'),
    (3, 252, 9, 9, '2017-03-01 15:22:12.956671', '2017-03-01 15:22:12.956671');")

  end

end
