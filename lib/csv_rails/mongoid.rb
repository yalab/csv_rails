module CsvRails
  module Mongoid
    def self.included(base)
      base.send(:include, CsvRails::ActiveModel::InstanceMethods)
      base.const_get(:ClassMethods).tap{|klass|
        klass.send(:include, CsvRails::ActiveModel::ClassMethods)
        klass.send(:include, ClassMethods)
      }
    end

    module ClassMethods
      def attribute_names
        fields.keys.map(&:to_sym)
      end
    end
  end
end
