# -*- coding: utf-8 -*-
require 'test_helper'
class CsvRails::ActiveRecordTest < ActiveSupport::TestCase
  setup do
    I18n.locale = :en
    @user = User.create(:name => 'yalab', :age => '29', :secret => 'password')
    @group = Group.create(:name => 'ruby')
    @user.groups << @group
  end

  test "#to_csv_ary without params" do
    assert_equal @user.attributes.length, @user.to_csv_ary.length
    assert_equal @user.attributes.values[0..-2], @user.to_csv_ary[0..-2]
  end

  test "#to_csv_ary with field params" do
    fields = [:name, :age]
    assert_equal fields.map{|f| @user[f] }, @user.to_csv_ary(fields)
  end

  test "#to_csv_ary use method not a database field" do
    assert_equal [@user.one], @user.to_csv_ary([:one])
  end

  test "#to_csv_ary can use association" do
    assert_equal [@user.name, @group.name], @user.memberships.first.to_csv_ary([:"user.name", :"group.name"])
  end

  test "#to_csv_ary ignore empty association" do
    name = 'noman'
    assert_equal [name, nil], User.new(:name => 'noman').to_csv_ary([:name, :"groups.first.name"])
  end

  test "#updated_at_as_csv" do
    assert_equal @user.updated_at.strftime("%F %H:%M"), @user.updated_at_as_csv
  end

  test ".to_csv without params" do
    csv = CSV.parse(User.to_csv)
    header = csv.first.map{|f| f.downcase.tr(' ', '_') }
    header.delete("updated_at")
    line = csv.last
    header.each.with_index do |field, index|
      assert_equal @user[field].to_s, line[index]
    end
  end

  test ".to_csv can use fields option" do
    fields = [:id, :name]
    row = CSV.parse(User.to_csv(:fields => fields)).last
    assert_equal fields.map{|f| @user[f].to_s }, row
  end

  test ".to_csv without_header" do
    fields = [:id, :name]
    row = CSV.parse(User.to_csv(:fields => fields, :without_header => true)).first
    assert_not_equal fields.map{|f| User.human_attribute_name(f) }, row
  end

  test ".to_csv header use human_attribute_name" do
    fields = [:id, :name, :one]
    header = CSV.parse(User.to_csv(:fields => fields)).first
    assert_equal fields.map{|f| User.human_attribute_name(f) }, header
  end

  test ".to_csv with scoped" do
    User.create(:name => 'atsushi', :age => 45, :secret => 'none')
    assert_equal 1, CSV.parse(User.where("age > 39").to_csv(:without_header => true)).length
  end

  test ".to_csv accept encoding" do
    I18n.locale = :ja
    assert_equal "名前".encode('SJIS'), CSV.parse(User.to_csv(:fields => [:name], :encoding => 'SJIS')).first.first
    I18n.locale = :en
  end

  test ".to_csv with association" do
    I18n.locale = :ja
    csv =<<-EOS.gsub(/^\s+/, '')
      #{User.human_attribute_name(:name)},#{Group.human_attribute_name(:name)}
      #{@user.name},#{@group.name}
    EOS
    assert_equal csv, User.includes(:groups).to_csv(:fields => [:name, :"groups.first.name"])
    I18n.locale = :en
  end

  test ".to_csv with i18n option" do
    I18n.locale = :ja
    translated = [:id].map{|f| I18n.t("csv_rails.#{f}") }.join(',')
    assert_match /^#{translated},#{User.human_attribute_name(:name)}/, User.where('id < 1').to_csv(:i18n_scope => 'csv_rails')
    I18n.locale = :en
  end

  test ".to_csv with association using as_csv" do
    assert_equal @group.created_at_as_csv, User.includes(:groups).to_csv(:fields => [:"groups.first.created_at"], :without_header => true).chomp
  end

  test ".to_csv with row_sep option" do
    assert_match /\r\n/, User.all.to_a.to_csv(:row_sep => "\r\n")
  end
end
