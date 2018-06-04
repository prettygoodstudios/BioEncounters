class RemoveEncounterFromSpecie < ActiveRecord::Migration[5.1]
  def change
    remove_column :species, :encounter_id, :integer
  end
end
