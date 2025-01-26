create or replace function renalware.feed_msgs_upsert_from_mirth(
  _sent_at timestamp,
  _message_type renalware.hl7_message_type,
  _event_type renalware.hl7_event_type,
  _message_control_id varchar,
  _nhs_number varchar,
  _local_patient_id varchar,
  _local_patient_id_2 varchar,
  _local_patient_id_3 varchar,
  _local_patient_id_4 varchar,
  _local_patient_id_5 varchar,
  _dob date,
  _orc_filler_order_number varchar,
  _orc_order_status renalware.enum_hl7_orc_order_status,
  _body text
)
/*
 * Fn called by mirth to upsert a row into the feed_msgs table.
 */
RETURNS TABLE(msg_id bigint, msg_queue_id bigint)
  AS $$
  declare id_of_inserted_feed_msg bigint;
  declare id_of_inserted_feed_msg_queue bigint;
  BEGIN

    insert into renalware.feed_msgs (
      sent_at,
      message_type,
      event_type,
      message_control_id,
      nhs_number,
      local_patient_id,
      local_patient_id_2,
      local_patient_id_3,
      local_patient_id_4,
      local_patient_id_5,
      dob,
      orc_filler_order_number,
      orc_order_status,
      body,
      created_at,
      updated_at
    ) values (
      _sent_at,
      _message_type,
      _event_type,
      _message_control_id,
      _nhs_number,
      _local_patient_id,
      _local_patient_id_2,
      _local_patient_id_3,
      _local_patient_id_4,
      _local_patient_id_5,
      _dob,
      _orc_filler_order_number,
      _orc_order_status,
      _body,
      current_timestamp,
      current_timestamp
    )
    RETURNING feed_msgs.id into id_of_inserted_feed_msg;

    --
    if id_of_inserted_feed_msg > 0 then
      insert into renalware.feed_msg_queue (feed_msg_id, created_at, updated_at)
      values (id_of_inserted_feed_msg, current_timestamp, current_timestamp)
      returning feed_msg_queue.id into id_of_inserted_feed_msg_queue;
    end if;

    return query(select id_of_inserted_feed_msg, id_of_inserted_feed_msg_queue);
  END;
$$ LANGUAGE plpgsql;
