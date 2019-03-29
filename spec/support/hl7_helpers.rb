# frozen_string_literal: true

module HL7Helpers
  def hl7_message_from_file(filename, patient)
    result = parse_hl7_file(filename, patient)
    Renalware::Feeds::HL7Message.new(::HL7::Message.new(result.lines))
  end

  def parse_hl7_file(filename, patient, pid = nil)
    body = file_fixture("hl7/#{filename}.hl7.erb").read
    ERB.new(body).result(binding)
  end
end
