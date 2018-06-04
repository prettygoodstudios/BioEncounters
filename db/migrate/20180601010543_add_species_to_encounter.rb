class AddSpeciesToEncounter < ActiveRecord::Migration[5.1]
  def change
    add_column :encounters, :specie_id, :integer
  end
end
