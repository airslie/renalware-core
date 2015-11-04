module Renalware
  module FlashHelper

    STYLES = { notice: "success", error: "alert", warning: "warning" }

    def flash_style(name)
      STYLES[name.to_sym]
    end

  end
end