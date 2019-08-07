class AddSlugToEncounters < ActiveRecord::Migration[5.1]
  def change
    add_column :encounters, :slug, :string
  end
end
