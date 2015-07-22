module LettersHelper

  def author_view?(letter)
    current_page?(action: 'author', author_id: letter.author.to_param)
  end

  def descriptions_options(selected)
    options_from_collection_for_select(LetterDescription.all, :id, :text, selected)
  end

  def authors_options
    options_from_collection_for_select(User.author, :id, :full_name)
  end

  def clinic_dates_options(patient)
    options_from_collection_for_select(Clinic.where(patient: patient), :id, :date)
  end

  def patient_medications(letter)
    if letter.patient.medications.any?
      medications = letter.patient.medications.map{|m| medication_list_item(m)}.join.html_safe
      patient_history_element('Medications', medications)
    end
  end

  def patient_problems(letter)
    if letter.patient.problems.any?
      problems = letter.patient.problems.map{|p| content_tag(:li, p.formatted)}.join.html_safe
      patient_history_element('Problems', problems)
    end
  end

  def letter_info(letter)
    patient = letter.patient
    info = "Patient: #{patient.full_name}"
    info << ", Doctor: #{patient.doctor.full_name}" if patient.doctor.present?
    info << ", Clinic date: #{letter.clinic_visit.date}" if letter.clinic_letter?
    info
  end

  def recipient_address(letter)
    if letter.recipient_address.present?
      letter.recipient_address.to_s(:street_1, :street_2, :city, :postcode)
    end
  end

  private

  def patient_history_element(title, items)
    content_tag(:div, content_tag(:h6, title) + content_tag(:ul, items), class: 'columns inline large-6')
  end

  def medication_list_item(medication)
    if medication.date > 14.days.ago
      content_tag(:li, medication.formatted, class: 'strong')
    else
      content_tag(:li, medication.formatted)
    end
  end
end
