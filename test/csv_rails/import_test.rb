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

  test "import with fields option" do
    user = {name: 'atsushi', age: 14}
    csv = <<-EOS
      #{user.values.join(',')}
    EOS
    users = User.csv_import(StringIO.new(csv.gsub(/^\s*/, '')), fields: user.keys)
    user.each do |k, v|
      assert_equal v, users.first[k]
    end
  end

  test "import skip blank line" do
    csv = <<-EOS
      name,age

      yoshida,30
    EOS
    User.csv_import(csv.gsub(/^\s*/, ''))
    assert_equal 1, User.count
  end

  test "import skip if block returns false" do
    User.csv_import(@csv) do |user|
      next false if user.id == 2
    end
    assert_nil User.find_by_id(2)
  end

  test "import is transaction" do
    User.csv_import(@csv) do |user, attributes, index|
      raise ActiveRecord::Rollback if index == 2
    end
    assert_nil User.find_by_id(1)
  end
end
