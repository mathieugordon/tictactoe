class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :player_x_id
      t.integer :player_o_id
      t.boolean :complete?
      t.integer :winner
      t.integer :loser

      t.timestamps
    end
  end
end
