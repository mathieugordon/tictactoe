class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.role? :admin
      can :manage, :all
    elsif user.persisted?
      can :read, User
      can :update, User, id: user.id
      can :create, Match
      can [:read, :move], Match do |match|
        match.player_x_id == user.id || match.player_o_id == user.id
      end
    else
      can :read, User
    end
  end

end