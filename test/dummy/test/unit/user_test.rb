require 'test_helper'
require 'csv'
class UserTest < ActiveSupport::TestCase
  setup do
    @user = User.create(:name => 'yalab', :age => '29', :secret => 'password')
  end
  test "to_csv" do
    assert CSV.parse(User.to_csv).first.include?(@user.name)
  end
end
