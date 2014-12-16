class Move < ActiveRecord::Base
  belongs_to :match
  belongs_to :player, class_name: "User"
end