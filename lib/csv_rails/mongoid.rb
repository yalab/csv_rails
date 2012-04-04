module CsvRails
  module Mongoid
    def self.included(base)
      base.send(:include, CsvRails::ActiveModel::InstanceMethods)
      base.const_get(:ClassMethods).send(:include, CsvRails::ActiveModel::ClassMethods)
    end

    def attribute_names
      fields.keys.reject{|k| k == '_type' }.map(&:to_sym)
    end
  end
end