class CreateMoves < ActiveRecord::Migration
  def change
    create_table :moves do |t|
      t.integer :match_id
      t.integer :player_id
      t.integer :cell
      t.string :marker

      t.timestamps
    end
  end
end
