class AddEncounterToSpecie < ActiveRecord::Migration[5.1]
  def change
    add_column :species, :encounter_id, :integer
  end
end
