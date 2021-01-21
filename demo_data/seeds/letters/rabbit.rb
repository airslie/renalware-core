# frozen_string_literal: true

module Renalware
  log "Assign Letters to Roger RABBIT" do
    patient = Letters.cast_patient(Patient.find_by(local_patient_id: "Z100001"))
    clinics_patient = Renalware::Clinics.cast_patient(patient)
    patient.letters.each { |letter| letter.archive&.destroy! }
    patient.letters.destroy_all
    users = User.limit(3).to_a

    letter_body = <<-TEXT
      Cras justo odio, dapibus ac facilisis in, egestas eget quam. Curabitur blandit tempus porttitor. Integer posuere erat a ante venenatis dapibus posuere velit aliquet. Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum. Nullam id dolor id nibh ultricies vehicula ut id elit. Nulla vitae elit libero, a pharetra augue. Nulla vitae elit libero, a pharetra augue.

      Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Sed posuere consectetur est at lobortis. Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor. Curabitur blandit tempus porttitor. Morbi leo risus, porta ac consectetur ac, vestibulum at eros. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nullam id dolor id nibh ultricies vehicula ut id elit.

      Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ullamcorper nulla non metus auctor fringilla. Vestibulum id ligula porta felis euismod semper. Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor. Etiam porta sem malesuada magna mollis euismod. Donec ullamcorper nulla non metus auctor fringilla.

      Yours sincerely
    TEXT

    contacts = patient.contacts.limit(2).to_a
    Letters::Letter::Draft.create!(
      patient: patient,
      issued_on: 2.days.ago,
      description: Renalware::Letters::Description.first.text,
      salutation: "Dear Dr Runner",
      main_recipient_attributes: {
        person_role: "primary_care_physician"
      },
      cc_recipients_attributes: [
        { person_role: "contact", addressee: contacts.first },
        { person_role: "contact", addressee: contacts.last }
      ],
      body: letter_body,
      notes: "Waiting on lab results.",
      letterhead: Renalware::Letters::Letterhead.first,
      author: users.sample,
      by: users.sample
    )

    Letters::Letter::Draft.create!(
      patient: patient,
      event: clinics_patient.clinic_visits.first,
      clinical: true,
      issued_on: 1.day.ago,
      description: Renalware::Letters::Description.first.text,
      salutation: "Dear Mr Rabbit",
      main_recipient_attributes: {
        person_role: "patient"
      },
      body: letter_body,
      notes: "You visited the clinic yesterday.",
      letterhead: Renalware::Letters::Letterhead.first,
      author: users.sample,
      by: users.sample
    )

    contact = patient.contacts.first!
    Letters::Letter::PendingReview.create!(
      patient: patient,
      issued_on: 3.days.ago,
      pathology_timestamp: 1.day.ago,
      description: Renalware::Letters::Description.last.text,
      main_recipient_attributes: {
        person_role: "contact",
        addressee: contact
      },
      salutation: "Dear #{contact.address_name}",
      body: letter_body,
      letterhead: Renalware::Letters::Letterhead.last,
      author: users.sample,
      by: users.sample
    )

    letter = Letters::Letter::PendingReview.create!(
      patient: patient,
      issued_on: 1.day.ago,
      pathology_timestamp: 1.day.ago,
      event: clinics_patient.clinic_visits.first,
      clinical: true,
      description: Renalware::Letters::Description.last.text,
      main_recipient_attributes: {
        person_role: "patient"
      },
      salutation: "Dear Mr Rabbit",
      body: letter_body,
      letterhead: Renalware::Letters::Letterhead.last,
      author: users.sample,
      by: users.sample
    )
    Renalware::Letters::ApproveLetter.build(letter).call(by: users.sample)
  end
end
