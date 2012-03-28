require 'test_helper'

class CsvRails::ArrayTest < ActiveSupport::TestCase
  test ".to_csv with header option" do
    header = ['foo', 'bar']
    assert_equal  header.join(','), [].to_csv(:header => header).chomp
  end
end
