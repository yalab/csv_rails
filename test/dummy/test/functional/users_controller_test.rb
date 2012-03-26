# -*- coding: utf-8 -*-
require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    User.create(:name => 'yalab', :age => '4', :secret => 'secret')
    I18n.locale = :ja
    @csv = User.all.to_csv(:fields => [:id, :name, :age])
  end
  test "should get index" do
    get :index, :format => 'csv'
    assert_equal @csv, response.body
  end

  test "should get sjis" do
    get :sjis, :format => 'csv'
    assert_equal @csv.encode('SJIS'), response.body
  end
  teardown do
    I18n.locale = :en
  end
end
