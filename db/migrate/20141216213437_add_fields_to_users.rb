class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :role, :string
    add_column :users, :name, :string
    add_column :users, :profile_text, :text
    add_column :users, :user_image, :string
  end
end
