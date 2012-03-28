# -*- coding: utf-8 -*-
require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    User.create(:name => 'yalab', :age => '4', :secret => 'secret')
    I18n.locale = :ja
    @fields = [:id, :name, :age, :"groups.first.name"]
  end

  test "should get index" do
    get :index, :format => 'csv'
    assert_equal User.all.to_csv(fields: @fields, without_header: true), response.body
  end

  test "should get sjis" do
    get :sjis, :format => 'csv'
    assert_equal User.all.to_csv(fields: @fields).encode('SJIS'), response.body
  end

  teardown do
    I18n.locale = :en
  end
end
