class AddUserToSpecie < ActiveRecord::Migration[5.1]
  def change
    add_column :species, :user_id, :integer
  end
end
