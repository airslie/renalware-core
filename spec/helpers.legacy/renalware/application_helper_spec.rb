require "rails_helper"

module Renalware
  describe ApplicationHelper, type: :helper do
    describe ".flash_messages" do
      it "returns alert, notice and success flash message" do
        allow(helper).to receive(:flash).and_return({
                                                      alert: [:alert_message],
          notice: [:notice_message],
          success: [:success_message],
          timedout: [true]
                                                    })
        expect(helper.flash_messages).to eq(
          { alert: [:alert_message], notice: [:notice_message], success: [:success_message] }
        )
      end
    end
  end
end
