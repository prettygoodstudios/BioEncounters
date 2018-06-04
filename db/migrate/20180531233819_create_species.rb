class CreateSpecies < ActiveRecord::Migration[5.1]
  def change
    create_table :species do |t|
      t.string :scientific
      t.string :common

      t.timestamps
    end
  end
end
