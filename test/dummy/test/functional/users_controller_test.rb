# -*- coding: utf-8 -*-
require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    User.create(:name => 'yalab', :age => '4', :secret => 'secret')
  end
  test "should get index" do
    I18n.locale = :ja
    get :index, :format => 'csv'
    csv = <<-EOS.gsub(/^\s+/, '')
      ID,名前,年齢
      1,yalab,4
    EOS

    assert_equal csv, response.body
  end
end
