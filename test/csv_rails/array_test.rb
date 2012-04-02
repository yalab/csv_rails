# -*- coding: utf-8 -*-
require 'test_helper'

class CsvRails::ArrayTest < ActiveSupport::TestCase
  setup do
    I18n.locale = :ja
    @csv_rails_scope = {name: "名前", age: "年齢"}
    @human_scope = {sex: '性別'}
    I18n.backend.store_translations(:ja, :csv_rails => @csv_rails_scope, :human => @human_scope)
  end

  teardown do
    I18n.locale = :en
  end

  test ".to_csv with header option" do
    header = ['foo', 'bar']
    assert_equal  header.join(','), [].to_csv(:header => header).chomp
  end

  test ".to_csv using I18n csv_rails scope and accept i18n_scope option" do
    translations = @csv_rails_scope.merge(@human_scope)
    fields = translations.keys
    assert_equal translations.values.join(','), [].to_csv(:fields => fields, :i18n_scope => :human).chomp
  end

  test ".to_csv not stored i18n" do
    fields = [:sum, :max]
    assert_equal fields.join(','), [].to_csv(:fields => fields).chomp
  end

  test ".to_csv accept encoding" do
    name = "名前"
    assert_equal name.encode('SJIS'), [].to_csv(:header => [name], :encoding => 'SJIS').chomp
  end

  test ".to_csv only it includes ActiveRecord instance" do
    assert_nothing_raised do
      [User.create(:name => 'satomicchy')].to_csv
    end
  end
end
