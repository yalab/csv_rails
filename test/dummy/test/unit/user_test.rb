require 'test_helper'
require 'csv'
class UserTest < ActiveSupport::TestCase
  setup do
    @user = User.create(:name => 'yalab', :age => '29', :secret => 'password')
  end

  test "#to_csv_ary without params" do
    assert_equal @user.attributes.length, @user.to_csv_ary.length
    assert_equal @user.attributes.values, @user.to_csv_ary
  end

  test "#to_csv_ary with field params" do
    fields = [:name, :age]
    assert_equal fields.map{|f| @user[f] }, @user.to_csv_ary(fields)
  end

  test "#updated_at_as_csv" do
    assert_equal @user.updated_at.strftime("%F %H:%M"), @user.updated_at_as_csv
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
