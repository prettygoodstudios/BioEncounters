class AddSlugToSpecies < ActiveRecord::Migration[5.1]
  def change
    add_column :species, :slug, :string
  end
end
