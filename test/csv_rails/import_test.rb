# -*- coding: utf-8 -*-
require 'test_helper'

class CsvRails::ImportTest < ActiveSupport::TestCase
  setup do
    I18n.locale = :en
    @users = [{id: 1, name: 'yoshida', age: 30, secret: 'password'},
              {id: 2, name: 'yalab',   age: 3,  secret: 'password'}]
    csv = <<-EOS.gsub(/^\s+/, '')
      id,name,age,secret
      #{@users[0].values.join(',')}
      #{@users[1].values.join(',')}
    EOS
    @csv = StringIO.new(csv)
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
    csv = <<-EOS.gsub(/^\s*/, '')
      #{user.values.join(',')}
    EOS
    users = User.csv_import(StringIO.new(csv), fields: user.keys)
    user.each do |k, v|
      assert_equal v, users.first[k]
    end
  end

  test "import skip blank line" do
    csv = <<-EOS.gsub(/^\s*/, '')
      name,age

      yoshida,30
    EOS
    User.csv_import(csv)
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

  test "includes invalid attributes" do
    User.module_eval do
      validates :name, presence: true
    end
    csv =<<-EOS.gsub(/^\s*/, '')
      name,age
      ,30
      yoshida,12
    EOS
    users = User.csv_import(csv)
    assert_equal 0, User.count
    assert_equal ["Name can't be blank"], users[0].errors.full_messages
  end

  test "import can accept not a column" do
    csv =<<-EOS.gsub(/^\s*/, '')
      name,age,group_name
      yoshida,12,human
    EOS
    assert_difference("User.count") do
      User.csv_import(csv) do |user, attributes|
        assert_equal 'human', attributes[:group_name]
      end
    end
  end

  test "it also use tsv_import" do
    secret = 'hogehoge'
    User.tsv_import(@csv.read.gsub(/,/, "\t")) do |user, params, ix|
      user.secret = secret if user.name == 'yalab'
    end
    @users.each do |params|
      user = User.find_by_id(params[:id])
      params.each do |k, v|
        if k == :secret && user.name == 'yalab'
          v = secret
        end
        assert_equal v, user[k]
      end
    end
  end

  test "inverse_human_attriute_name" do
    I18n.locale = :ja
    assert_equal :name, User.inverse_human_attriute_name("名前")
  end

  test "csv download upload" do
    I18n.locale = :ja
    user = User.create(name: 'foobar', age: 20)
    User.csv_import(User.to_csv.gsub('foobar', 'hogehoge'))
    assert_equal 'hogehoge', user.reload.name
  end

  test "import can choose key" do
    csv =<<-EOS.gsub(/^\s*/, '')
      name,age,group_name
      yoshida,12,human
      yoshida,15,human
    EOS
    User.csv_import(csv, find_key: :name)
    assert_equal 1, User.count
    assert_equal 15, User.find(1).age
  end
end
