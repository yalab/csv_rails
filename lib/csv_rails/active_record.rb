require 'csv'
module CsvRails
  module ActiveRecord
    def self.included(base)
      base.extend ClassMethods
      ::ActiveRecord::Relation.send(:include, ClassMethods)
      base.send(:include, InstanceMethods)
    end

    module ClassMethods
      def to_csv(opts={})
        fields = if opts[:fields]
                   opts.delete(:fields)
                 elsif respond_to?(:attribute_names)
                   attribute_names
                 elsif self.is_a?(::ActiveRecord::Relation)
                   @klass.new.attribute_names
                 else
                   new.attribute_names
                 end
        csv = CSV.generate do |_csv|
          _csv << fields.map{|f| human_attribute_name(f) } unless opts[:without_header]
          all.each{|row| _csv << row.to_csv_ary(fields) }
        end
        opts[:encoding] ? csv.encode(opts[:encoding]) : csv
      end
    end

    module InstanceMethods
      def to_csv_ary(fields=nil, opts={})
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
