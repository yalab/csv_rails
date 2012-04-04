module CsvRails
  module Mongoid
    def self.included(base)
      base.send(:include, CsvRails::ActiveModel)
      base.send(:include, ClassMethods)
    end

    module ClassMethods
      def attribute_names
        fields.keys.reject{|k| k == '_type' }.map(&:to_sym)
      end
    end
  end
end
