# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin?
      can :manage, :all
      can :import, :all
    elsif user.regular?
      can :read, :all
    end
  end
end
