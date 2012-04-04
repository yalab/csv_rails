# -*- coding: utf-8 -*-
require 'test_helper'

class CsvRails::MongoidTest < ActiveSupport::TestCase
  setup do
    Post.create(:title => 'title', :body => "foobar")
  end

  test ".to_csv" do
    assert_equal "Title,Body\ntitle,foobar\n", Post.where(:title => 'title').to_csv(:fields => [:title, :body])
  end
end
