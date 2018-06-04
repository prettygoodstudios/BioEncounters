class CreateEncounters < ActiveRecord::Migration[5.1]
  def change
    create_table :encounters do |t|
      t.date :date
      t.string :description

      t.timestamps
    end
  end
end
