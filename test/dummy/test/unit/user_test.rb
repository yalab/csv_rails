require 'test_helper'
require 'csv'
class UserTest < ActiveSupport::TestCase
  setup do
    @user = User.create(:name => 'yalab', :age => '29', :secret => 'password')
  end

  test ".to_csv without params" do
    csv = CSV.parse(User.to_csv)
    header = csv.first
    line = csv.last
    header.each.with_index do |field, index|
      assert_equal @user[field].to_s, line[index]
    end
  end
end
