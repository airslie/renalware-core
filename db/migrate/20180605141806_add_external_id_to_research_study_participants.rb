class AddExternalIdToResearchStudyParticipants < ActiveRecord::Migration[5.1]
  def change
    # The external_id is for obfuscating the participant id using a random integer.
    # It is used e.g. when passing to an external research application
    add_column(
      :research_study_participants,
      :external_id,
      :integer,
      null: true
    )

    reversible do |direction|
      direction.up do
        # Create a function the trigger will call..
        load_function("update_research_study_participants_from_trigger_v01.sql")

        # .. and the trigger when a row is inserted
        load_trigger("update_research_study_participants_trigger_v01.sql")

        # Populate the just-created external_id column with the correct value that the trigger
        # would otherwise create if it were added in the future.
        connection.execute(
          "UPDATE renalware.research_study_participants SET external_id = renalware.pseudo_encrypt(id::integer) where external_id is NULL;"
        )
      end
      direction.down do
        connection.execute("
          DROP TRIGGER IF EXISTS update_research_study_participants_trigger ON renalware.research_study_participants;
          DROP FUNCTION IF EXISTS update_research_study_participants_from_trigger();
        ")
      end
    end

    # Now we have created and populated the external_id we need to add a unique index.
    # external_id is guaranteed to be unique because the generating function (called by the
    # trigger when a row is inserted) is based on the id.
    # See db/functions/update_research_study_participants_from_trigger_v01
    add_index :research_study_participants, :external_id, unique: true
  end
end
