class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :player_x_id
      t.integer :player_o_id
      t.boolean :complete?  ||= false
      t.integer :winning_player_id
      t.integer :losing_player_id

      t.timestamps
    end
  end
end
