# -*- coding: utf-8 -*-
require 'test_helper'

class CsvRails::ArrayTest < ActiveSupport::TestCase
  test ".to_csv with header option" do
    header = ['foo', 'bar']
    assert_equal  header.join(','), [].to_csv(:header => header).chomp
  end

  test ".to_csv accept encoding" do
    name = "名前"
    assert_equal name.encode('SJIS'), [].to_csv(:header => [name], :encoding => 'SJIS').chomp
  end

  test ".to_csv only it includes ActiveRecord instance" do
    [User.create(:name => 'satomicchy')].to_csv
  end
end
