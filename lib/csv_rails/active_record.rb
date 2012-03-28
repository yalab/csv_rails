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
        header = fields.map{|f| human_attribute_name(f) }
        all.to_csv(opts.update(:fields => fields, :header => header))
      end

      def csv_header(names)
        names.map{|n| human_attribute_name(n) }
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
