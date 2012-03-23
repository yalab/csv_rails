class User < ActiveRecord::Base
  def updated_at_as_csv
    self.updated_at.strftime("%F %H:%M")
  end
end
