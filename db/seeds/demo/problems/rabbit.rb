module Renalware
  log '--------------------Adding Problems for Roger RABBIT--------------------'

  rabbit = Patient.find_by(family_name: 'RABBIT', given_name: 'Roger')

  randweeks = (0..52).to_a
  file_path = File.join(File.dirname(__FILE__), 'rabbit_problems.csv')
  logcount=0

  Problems::Problem.where(patient_id: rabbit.id).destroy_all

  CSV.foreach(file_path, headers: true) do |row|
    randwk = randweeks.sample
    date = Time.now - randwk.weeks
    description = row['description']
    log "   ... adding #{description} from #{date}"
    logcount += 1
    Problems::Problem.create!(
      patient_id: rabbit.to_param,
      description: description,
      date: date,
      position: logcount
    )
  end

  log "#{logcount} Problems seeded"

  log '--------------------Adding Problem Notes for Roger RABBIT--------------------'

  rabbit = Patient.find_by(family_name: 'RABBIT', given_name: 'Roger')
  problem_ids = Problems::Problem.where(patient_id: rabbit.id).pluck(:id)
  users = User.limit(3).to_a

  file_path = File.join(File.dirname(__FILE__), 'rabbit_problem_notes.csv')
  logcount=0

  CSV.foreach(file_path, headers: true) do |row|
    description = row['description']
    problem_index = row['problem_index'].to_i
    logcount += 1
    Problems::Note.find_or_create_by!(
      problem_id: problem_ids[problem_index],
      description: description
    ) do |note|
      note.by = users.sample
    end
  end

  log "#{logcount} Problem Notes seeded"
end
