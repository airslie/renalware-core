class UpdateHeroicParticipantsToV3 < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema(suffix: :heroic) do
      replace_view(
        :heroic_participants,
        version: 3,
        revert_to_version: 2
      )
    end
  end
end
