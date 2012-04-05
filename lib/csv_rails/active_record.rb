module CsvRails
  module ActiveRecord
    def self.included(base)
      base.extend(CsvRails::ActiveModel::ClassMethods)
      base.send(:include, CsvRails::ActiveModel::InstanceMethods)
      ::ActiveRecord::Relation.send(:include, CsvRails::ActiveModel::ClassMethods)
      unless base.respond_to?(:attribute_names)
        base.extend(ClassMethods) # for rails 3.0.12
      end
    end

    module ClassMethods
      def attribute_names
        column_names.map(&:to_sym)
      end
    end
  end
end
