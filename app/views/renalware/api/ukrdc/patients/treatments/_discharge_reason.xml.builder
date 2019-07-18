# frozen_string_literal: true

xml = builder

if treatment&.discharge_reason_code.present?
  xml.DischargeReason do
    xml.CodingStandard "CF_RR7_DISCHARGE"
    xml.Code treatment.discharge_reason_code
  end
end
