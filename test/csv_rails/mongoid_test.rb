# -*- coding: utf-8 -*-
require 'test_helper'

class CsvRails::MongoidTest < ActiveSupport::TestCase
  setup do
    Post.create(:title => 'title', :body => "foobar") if Post.where(:title => 'title').length < 1
  end

  teardown do
    I18n.locale = :en
  end

  test ".to_csv" do
    assert_equal "Title,Body\ntitle,foobar\n", Post.where(:title => 'title').to_csv(:fields => [:title, :body])
  end

  test ".to_csv with ja locale" do
    I18n.locale = :ja
    assert_equal "タイトル,本文\ntitle,foobar\n", Post.where(:title => 'title').to_csv(:fields => [:title, :body])
  end
end
