class User < ActiveRecord::Base
  has_many :moves
  has_many :player_x_matches, class_name: "Match", foreign_key: :player_x_id
  has_many :player_o_matches, class_name: "Match", foreign_key: :player_o_id
  has_many :winning_player_matches, class_name: "Match", foreign_key: :winning_player_id
  has_many :losing_player_matches, class_name: "Match", foreign_key: :losing_player_id

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def role?(role_to_compare)
    self.role.to_s == role_to_compare.to_s
  end

end
