require_relative "../../seeds_helper"

module Renalware
  Rails.benchmark "Adding Transplant Registration Statuses" do
    # HC on #1664: The only difficulty is for patients who receive a pre-emptive transplant so
    # their ESRF date is the date of their transplant. The RR list does not
    # accommodate that but I would put them as On Transplant List (3)
    #
    # RR ESR61 codes:
    # 1 Unsuitable
    # 2 Working Up or under discussion
    # 3 On Transplant List
    # 4 Suspended on Transplant List
    # 5 Not Assessed by Start of Dialysis
    statuses = [
      [:active, "Active", 3, "ESRF61: On Transplant List", 3, "A"],
      [:suspended, "Suspended", 4, "ESRF61: Suspended on Transplant List", 1, "S"],
      [:transplanted, "Transplanted", nil, "Not relevant for ESRF61", 3, "T"],
      [:live_transplanted, "Live transplanted", nil, "Not relevant for ESRF61", 3, "T"],
      [:off_by_patient, "Off by patient request", 1, "ERF61: Unsuitable", 1, "R"],
      [:not_eligible, "Not eligible for NHS Tx", 1, "ERF61: Unsuitable", 1, "R"],
      [:unfit_reconsider, "Unfit (not listed -- reconsider)", 1, "ERF61: Unsuitable", 1, "R"],
      [:unfit_permanent, "Unfit (not listed -- permanent)", 1, "ERF61: Unsuitable", 1, "R"],
      [:working_up, "X - working up", 2, "ERF61: Working Up or under discussion", 2, "W"],
      [:working_up_lrf, "X - working up LRF", 2, "ERF61: Working Up or under discussion", 2, "W"],
      [:not_for_work_up, "Not for work up - eGFR too high", 1, "ERF61: Unsuitable", 1, "R"],
      [:workup_complete, "Workup complete - low creat", 2, "ERF61: Working Up or under discussion", 3, "W"],
      [:transfer_out, "Transfer Out", nil, "Not relevant for ESRF61", 1, "R"],
      [:died, "Died", nil, "Not relevant for ESRF61", 1, "R"]
    ]

    {
      "A" => "Active",
      "S" => "Suspended",
      "R" => "Removed",
      "T" => "Transplanted",
      "W" => "Work-up"
    }.each do |code, name|
      Transplants::RegistrationNHSBTStatusDescription.find_or_create_by(code: code) do |desc|
        desc.name = name
      end
    end

    statuses.each_with_index do |status, index|
      Transplants::RegistrationStatusDescription.find_or_create_by(code: status[0]) do |desc|
        desc.name = status[1]
        desc.rr_code = status[2]
        desc.rr_comment = status[3]
        desc.ukrdc_assessment_outcome_code = status[4]
        desc.nhsbt_status_code = status[5]
        desc.position = index * 10
      end
    end
  end
end
