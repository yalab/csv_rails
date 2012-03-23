require 'csv'
module ActiveRecord
  module Acts
    module Csv
      def self.included(base)
        base.extend ClassMethods
        base.send(:include, InstanceMethods)
      end

      module ClassMethods
        def to_csv
          CSV.generate do |csv|
            all.each{|row| csv << row.to_a }
          end
        end
      end

      module InstanceMethods
        def to_a
          self.class.attribute_names.map{|attribute| self[attribute] }
        end
      end
    end
  end
end
