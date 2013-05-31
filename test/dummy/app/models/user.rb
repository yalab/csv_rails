class User < ActiveRecord::Base
  has_many :memberships
  has_many :groups, through: :memberships
  include CsvRails::Import

  def updated_at_as_csv
    self.updated_at.strftime("%F %H:%M")
  end

  def one
    1
  end
end
