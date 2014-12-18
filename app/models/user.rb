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

  mount_uploader :user_image, UserImageUploader

  def role?(role_to_compare)
    self.role.to_s == role_to_compare.to_s
  end

  def matches_by_status(status)
    player_x_matches.where(status: status).count + player_o_matches.where(status: status).count
  end

  def matches() player_x_matches.count + player_o_matches.count end
  def matches_in_progress() matches_by_status("in progress") end
  def wins() winning_player_matches.count end
  def losses() losing_player_matches.count end
  def draws() matches_by_status("drawn") end 

end
