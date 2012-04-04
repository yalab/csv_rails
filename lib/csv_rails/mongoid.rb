module CsvRails
  module Mongoid
    def self.included(base)
      base.send(:include, CsvRails::ActiveModel)
      base.const_get(:ClassMethods).send(:include, CsvRails::ActiveModel::ClassMethods)
      base.send(:include, ClassMethods)
    end

    module ClassMethods
      def attribute_names
        fields.keys.reject{|k| k == '_type' }.map(&:to_sym)
      end
    end
  end
end
