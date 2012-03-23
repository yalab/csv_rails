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
            all.each{|row| csv << row.to_csv_ary(fields) }
          end
        end
      end

      module InstanceMethods
        def to_csv_ary(fields=nil)
          fields = attribute_names unless fields
          fields.map{|field|
            convert_method = "#{field}_as_csv"
            method = respond_to?(convert_method) ? convert_method : field
            send(method)
          }
        end
      end
    end
  end
end
