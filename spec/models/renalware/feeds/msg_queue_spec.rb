module Renalware
  describe Feeds::MsgQueue do
    it :aggregate_failures do
      is_expected.to have_db_index(:feed_msg_id)
    end
  end
end
