class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.role? :admin
        can :manage, :all
    elsif user.persisted?
        can :read, :all
        can :manage, :all #, user_id: user.id
    else
        can :read, :all
    end
  end

end
