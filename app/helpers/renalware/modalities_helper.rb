module Renalware
  module ModalitiesHelper

    def modal_reasons_for(type)
      Modalities::Reason.where(type: type)
    end

    def modal_change_options(selected = nil)
      options_for_select(
        [
          "Other",
          ["Haemodialysis To PD", "HaemodialysisToPD"],
          ["PD To Haemodialysis", "PDToHaemodialysis"]
        ],
        selected
      )
    end
  end
end
