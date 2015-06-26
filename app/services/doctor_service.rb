class DoctorService
  def initialize(doctor=Doctor.new)
    @doctor = doctor
  end

  def update!(params)
    update_practices(params.delete(:practice_ids))
    update_doctor(params)
    @doctor.save
  end

  private

  def update_doctor(params)
    @doctor.attributes = params
  end

  def update_practices(practices_ids)
    @doctor.practices = Practice.where(id: practices_ids)
  end
end
