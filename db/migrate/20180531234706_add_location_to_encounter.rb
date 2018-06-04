class AddLocationToEncounter < ActiveRecord::Migration[5.1]
  def change
    add_column :encounters, :location_id, :integer
  end
end
