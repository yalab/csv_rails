class Group < ActiveRecord::Base
  has_many :memberships
  has_many :users, through: :memberships

  def created_at_as_csv
    created_at.strftime("%F")
  end
end
