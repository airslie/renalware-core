require "rails_helper"

RSpec.describe "Simulation of Mirth inserting an HL7 message into delayed_jobs" do
  let(:hl7_with_uom_caret_encoded_as_slash_s_slash) do
    <<-RAW.strip_heredoc
     MSH|^~\&|HM|LBE|SCM||20091112164645||ORU^R01|1258271|P|2.3.1|||AL||||
     PID|||Z999990^^^PAS Number||RABBIT^JESSICA^^^MS||19880924|F|||18 RABBITHOLE ROAD^LONDON^^^SE8 8JR|||||||||||||||||||
     PV1||Inpatient|NIBC^^^^^^^^|||||MID^KINGS MIDWIVES||||||||||NHS|HXF888888^^^Visit Number|||||||||
     ORC|RE|^PCS|09B0099478^LA||CM||||200911111841|||MID^KINGS MIDWIVES|||||||
     OBR|1|123456^PCS|09B0099478^LA|FBC^FULL BLOOD COUNT^MB||200911111841|200911111841|||||||200911111841|B^Blood|MID^KINGS MIDWIVES||09B0099478||||200911121646||HM|F||||||||||||||||||
     OBX|1|TX|WBC^WBC^MB||6.09|10\\S\\12/L|||||F|||200911112026||BBKA^Kenneth AMENYAH|
   RAW
  end

  def simulate_mirth_inserting_a_new_hl7_message_into_delayed_jobs
    hl7_msg = hl7_with_uom_caret_encoded_as_slash_s_slash
    sql = <<-SQL
    insert into renalware.delayed_jobs (handler, run_at)
    values('--- !ruby/struct:FeedJob\nraw_message: |\n  ' || REPLACE('#{hl7_msg}',E'\r',E'\n  '), NOW());
    SQL
    ActiveRecord::Base.connection.execute(sql)
  end

  describe "postgres trigger" do
    it "replaces \S\ with \\S\\ when the handler+message are inserted into delayed_jobs" do
      expect{
        simulate_mirth_inserting_a_new_hl7_message_into_delayed_jobs
      }.to change{ Delayed::Job.count }.by(1)

      expected_obx_preprocessed_by_pg_trigger = "OBX|1|TX|WBC^WBC^MB||6.09|10\\\\S\\\\12/L|"
      expect(Delayed::Job.first.handler)
        .to include(expected_obx_preprocessed_by_pg_trigger)
    end
  end
end
