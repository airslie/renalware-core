module Renalware
  Rails.benchmark "Adding demo feeds messages" do
    sql = <<-SQL.squish
      INSERT INTO "renalware"."feed_messages" ("message_type", "event_type", "header_id", "body", "created_at", "updated_at", "body_hash", "nhs_number")
      VALUES ('ORU', 'R01', '1258271', 'MSH|^~\&|HM|LBE|SCM||20190327094925||ORU^R01|1258271|P|2.3.1|||AL||||
      PID|||Z999990^^^HOSP1||RABBIT^JESSICA^^^MS||19880924|F|||18 RABBITHOLE ROAD^LONDON^^^SE8 8JR|||||||||||||||||||
      PV1||Inpatient|NIBC^^^^^^^^|||||MID^KINGS MIDWIVES||||||||||NHS|HXF888888^^^Visit Number|||||||||
      ORC|RE|^PCS|09B0099478^LA||CM||||200911111841|||MID^KINGS MIDWIVES|||||||
      OBR|1|^PCS|09B0099478^LA|FBC^FULL BLOOD COUNT^MB||200911111841|200911111841|||||||200911111841|B^Blood|MID^KINGS MIDWIVES||09B0099478||||200911121646||HM|F||||||||||||||||||
      OBX|1|TX|WBC^WBC^MB||6.09||||||F|||200911112026||BBKA^Donald DUCK|
      OBX|2|TX|RBC^RBC^MB||4.00||||||F|||200911112026||BBKA^Donald DUCK|
      OBX|3|TX|HGB^Hb^MB||11.8||||||F|||200911112026||BBKA^Donald DUCK|
      OBX|4|TX|PCV^PCV^MB||0.344||||||F|||200911112026||BBKA^Donald DUCK|
      OBX|5|TX|MCV^MCV^MB||85.9||||||F|||200911112026||BBKA^Donald DUCK|
      OBX|6|TX|MCH^MCH^MB||29.5||||||F|||200911112026||BBKA^Donald DUCK|
      OBX|7|TX|MCHC^MCHC^MB||34.4||||||F|||200911112026||BBKA^Donald DUCK|
      OBX|8|TX|RDW^RDW^MB||13.3||||||F|||200911112026||BBKA^Donald DUCK|
      OBX|9|TX|PLT^PLT^MB||259||||||F|||200911112026||BBKA^Donald DUCK|
      OBX|10|TX|MPV^Mean Platelet Volume^MB||8.3||||||F|||200911112026||BBKA^Donald DUCK|
      OBX|11|TX|NRBC^Machine NRBC^MB||<0.2%||||||F|||200911112026||BBKA^Donald DUCK|
      OBX|12|TX|HYPO^% HYPO^MB||0.2||||||F|||200911112026||BBKA^Donald DUCK|
      OBX|13|TX|NEUT^Neutrophil Count^MB||  3.16||||||F|||200911121646||BHISVC01^BHI Authchecker|
      OBX|14|TX|LYM^Lymphocyte Count^MB||  2.32||||||F|||200911121646||BHISVC01^BHI Authchecker|
      OBX|15|TX|MON^Monocyte Count^MB||  0.44||||||F|||200911121646||BHISVC01^BHI Authchecker|
      OBX|16|TX|EOS^Eosinophil Count^MB||  0.15||||||F|||200911121646||BHISVC01^BHI Authchecker|
      OBX|17|TX|BASO^Basophils^MB||  0.02||||||F|||200911121646||BHISVC01^BHI Authchecker|',
      '2019-03-27 09:49:25.243927',
      '2019-03-27 09:49:25.243927',
      'e7b23c5f933d5c99914af2360e9420cc',
      'Z100002'
      );
    SQL
    ActiveRecord::Base.connection.execute(sql)
  end
end
