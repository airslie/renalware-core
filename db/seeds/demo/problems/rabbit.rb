module Renalware
  log "Adding Problems for Roger RABBIT"

  file_path = File.join(File.dirname(__FILE__), "rabbit_problems.csv")

  rabbit = Patient.find_by(family_name: "RABBIT", given_name: "Roger")
  rabbit.problems.destroy_all

  count = 0
  week_numbers = (0..52).to_a

  CSV.foreach(file_path, headers: true) do |row|
    random_week_number = week_numbers.sample

    Problems::Problem.create!(
      patient: rabbit,
      description: row["description"],
      date: Time.now - random_week_number.weeks,
      position: count += 1
    )
  end

  log "Adding Problem Notes for Roger RABBIT"

  file_path = File.join(File.dirname(__FILE__), "rabbit_problem_notes.csv")

  problem_ids = rabbit.problem_ids
  users = User.limit(3).to_a

  CSV.foreach(file_path, headers: true) do |row|
    problem_index = row["problem_index"].to_i

    Problems::Note.find_or_create_by!(
      problem_id: problem_ids[problem_index],
      description: row["description"]
    ) do |note|
      note.by = users.sample
    end
  end
end
