module Renalware

  username = "superbla"
  Renalware::User.find_or_create_by!(username: username) do |u|
    u.given_name = 'nn'
    u.family_name = "Superuser"
    u.email = "yay@trust.uk"
    u.password = "renalware"
    u.approved = true
    u.signature = "Superuser"
  end

  system_user = User.first
  demo_nhsno = 1350000000

  5000.times do |i|
    demo_nhsno += 1
    Patient.find_or_create_by!(local_patient_id: i.to_s) do |patient|
      patient.family_name = "J"
      patient.given_name = "X"
      patient.sex = "M"
      patient.born_on = "01-01-2001"
      patient.nhs_number = demo_nhsno
      patient.by = system_user

      ids = [
        demo_nhsno - 100001,
        demo_nhsno - 100002,
        demo_nhsno - 100003,
        demo_nhsno - 100004,
        demo_nhsno - 100005
      ]
      patient.local_patient_id = ids[0]
      patient.local_patient_id_2 = ids[1]
      patient.local_patient_id_3 = ids[2]
      patient.local_patient_id_4 = ids[3]
      patient.local_patient_id_5 = ids[4]
      patient.local_patient_ids = ids
      patient.local_ids = ids.each_with_index.map{ |a,idx| ["BLT#{idx}", a] }.to_h
    end
  end

   p Patient.count
  # con = ActiveRecord::Base.connection
  # ms = Benchmark.ms do
  #   1000.times do
  #     con.execute("select id from patients where '1229934733' = ANY (local_patient_ids);")
  #   end
  # end
  # p "A Took in #{ms / 1000}s"
  # ms = Benchmark.ms do
  #   1000.times do
  #     con.execute("select id from patients where
  #         local_patient_id = '1229934733' or
  #         local_patient_id_2 = '1229934733' or
  #         local_patient_id_3 = '1229934733' or
  #         local_patient_id_4 = '1229934733' or
  #         local_patient_id_5 = '1229934733';")
  #   end
  # end
  # p "B Took in #{ms / 1000}s"


end
