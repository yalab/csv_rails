module CsvRails
  module ActiveRecord
    def self.included(base)
      base.send(:include, CsvRails::ActiveModel)
      ::ActiveRecord::Relation.send(:include, CsvRails::ActiveModel::ClassMethods)
    end
  end
end
