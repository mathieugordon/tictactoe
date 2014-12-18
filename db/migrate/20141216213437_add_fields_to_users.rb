class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :role, :string, :default => "user"
    add_column :users, :name, :string
    add_column :users, :profile_text, :text, :default => "describe yourself!"
    add_column :users, :user_image, :string
    add_column :users, :wins, :integer, :default => 0
    add_column :users, :losses, :integer, :default => 0
    add_column :users, :draws, :integer, :default => 0
  end
end
