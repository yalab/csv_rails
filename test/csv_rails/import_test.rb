# -*- coding: utf-8 -*-
require 'test_helper'

class CsvRails::ImportTest < ActiveSupport::TestCase
  test "import IO" do
    csv = <<-EOS
      id,name,age,secret
      1,yoshida,30,password
      2,yalab,3,password
    EOS
    User.csv_import(StringIO.new(csv.gsub(/^\s+/, '')))
    yoshida = User.find(1)
    assert_equal 'yoshida',  yoshida.name
    assert_equal 30,         yoshida.age
    assert_equal 'password', yoshida.secret

    yalab = User.find(2)
    assert_equal 'yalab',    yalab.name
    assert_equal 3,          yalab.age
    assert_equal 'password', yalab.secret    
  end
end
