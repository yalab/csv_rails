# -*- coding: utf-8 -*-
require 'test_helper'

class CsvRails::ImportTest < ActiveSupport::TestCase
  setup do
    @users = [{id: 1, name: 'yoshida', age: 30, secret: 'password'},
              {id: 2, name: 'yalab',   age: 3,  secret: 'password'}]
    csv = <<-EOS
      id,name,age,secret
      #{@users[0].values.join(',')}
      #{@users[1].values.join(',')}
    EOS
    @csv = StringIO.new(csv.gsub(/^\s+/, ''))
  end

  test "import IO" do
    User.csv_import(@csv)
    @users.each do |params|
      user = User.find(params[:id])
      params.each do |k, v|
        assert_equal v, user[k]
      end
    end
  end

  test "import with block" do
    name = 'test'
    User.csv_import(@csv) do |user, params|
      if params[:id] == '1'
        user.name = name
      end
    end
    user = User.find(1)
    assert_equal name, user.name
  end
end
