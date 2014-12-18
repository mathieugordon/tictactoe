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

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :user_image, presence: true

  def role?(role_to_compare)
    self.role.to_s == role_to_compare.to_s
  end

  def update_counters!
    self.update(wins: number_of_wins, losses: number_of_losses, draws: number_of_draws)
  end

  def number_of_matches_by_status(status)
    player_x_matches.where(status: status).count + player_o_matches.where(status: status).count
  end

  def number_of_wins
    winning_player_matches.count
  end

  def number_of_losses
    losing_player_matches.count
  end

  def number_of_draws
    number_of_matches_by_status("drawn")
  end

end
