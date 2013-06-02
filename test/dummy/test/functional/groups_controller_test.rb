require 'test_helper'

class GroupsControllerTest < ActionController::TestCase
  setup do
    I18n.locale = :en
  end

  test "on POST create as csv" do
    post :create, group: {file: fixture_file_upload('groups.csv')}
    expects = {
      'Python' => [{name: 'atsushi', age: 30},
                   {name: 'taro',    age: 10}],
      'Perl'   => [{name: 'atsushi', age: 30},
                   {name: 'yoshida', age: 40}]
    }
    assert_equal 2, Group.count
    assert_equal 3, User.count
    expects.each do |group_name, members|
      group = Group.find_by_name(group_name)
      assert_equal group_name, group.name
      members.each do |member|
        assert_equal member[:age], group.users.where(name: member[:name]).first.age
      end
    end
  end

  test "on POST create as csv includes wrong user name" do
    post :create, group: {file: fixture_file_upload('groups_includes_wrong_user_name.csv')}
    assert_equal 0, Group.count
    assert_equal 0, User.count
    assigns(:groups).last.users.each do |user|
      assert_equal "Name can't be blank", user.errors.full_messages.first
    end
  end
end
