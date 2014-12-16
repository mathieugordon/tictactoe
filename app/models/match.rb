class Match < ActiveRecord::Base
  has_many :moves
  belongs_to :player_x, class_name: "User"
  belongs_to :player_o, class_name: "User"
end