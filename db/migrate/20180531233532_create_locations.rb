class CreateLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :locations do |t|
      t.string :title
      t.string :city
      t.string :state
      t.string :country
      t.string :address
      t.timestamps
    end
  end
end
