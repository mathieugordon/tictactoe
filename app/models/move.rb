class Move < ActiveRecord::Base
  belongs_to :match
  belongs_to :player, class_name: "User"

  validates :cell, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 8 }
  validates :cell, uniqueness: { scope: :match_id }

  validate :marker_is_x_or_o, on: :create

  validate :current_player, on: :create

  def marker_is_x_or_o
    errors.add(:marker, "should be X or O") unless marker == "X" || marker == "O"
  end

  def current_player
    errors.add(:player_id, "is not the current player") unless player_id == match.next_player.id
  end

end