class AddUserToEncounter < ActiveRecord::Migration[5.1]
  def change
    add_column :encounters, :user_id, :integer
  end
end
