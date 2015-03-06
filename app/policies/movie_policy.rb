class MoviePolicy < ApplicationPolicy
  attr_reader :user, :movie
  class Scope < Scope
    def resolve
      scope
    end
  end
  def initialize(user, movie)
    @user = user
    @movie = movie
  end
  def update?
    user.admin?
  end
  def edit?
    user.admin?
  end
  def destroy?
    user.admin?
  end
  def create?
    user.admin?
  end
end
