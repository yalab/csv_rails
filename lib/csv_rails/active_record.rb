module CsvRails
  module ActiveRecord
    def self.included(base)
      base.extend(CsvRails::ActiveModel::ClassMethods)
      base.send(:include, CsvRails::ActiveModel::InstanceMethods)
      ::ActiveRecord::Relation.send(:include, CsvRails::ActiveModel::ClassMethods)
    end
  end
end
