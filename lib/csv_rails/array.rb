require 'csv'
module CsvRails
  module Array
    def self.included(base)
      base.send(:remove_method, :to_csv)
      base.send(:include, CsvRails::Array::InstanceMethods)
    end

    module InstanceMethods
      def to_csv(opts={})
        return "" if length < 1
        first = self.first
        fields = opts.delete(:fields) || first.class.attribute_names
        csv = CSV.generate do |_csv|
          unless opts[:without_header]
            _csv << if first.class.respond_to?(:human_attribute_name)
                     fields.map{|f| first.class.human_attribute_name(f) }
                   else
                     fields
                   end
          end
          each do |element|
             _csv << element.to_csv_ary(fields, opts)
          end
        end
        opts[:encoding] ? csv.encode(opts[:encoding]) : csv
      end
    end
  end
end
