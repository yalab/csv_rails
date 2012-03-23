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
          fields = attribute_names
          CSV.generate do |csv|
            csv << fields
            all.each{|row| csv << row.to_a(fields) }
          end
        end
      end

      module InstanceMethods
        def to_a(fields)
          fields.map{|attribute| self[attribute] }
        end
      end
    end
  end
end
