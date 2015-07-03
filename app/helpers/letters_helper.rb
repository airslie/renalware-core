module LettersHelper

  def descriptions_options
    options_from_collection_for_select(LetterDescription.all, :id, :text)
  end

  def authors_options
    options_from_collection_for_select(User.author, :id, :full_name)
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

  def patient_and_doctor_info(patient)
    info = "Patient: #{patient.full_name}"
    info << ", Doctor: #{patient.doctor.full_name}" if patient.doctor.present?
    info
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
