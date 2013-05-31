module CsvRails::Import
  extend ActiveSupport::Concern
  module ClassMethods
    def csv_import(body, opts={})
      fields = opts[:fields]
      records = []
      CSV.parse(body).each do |row|
        unless fields
          fields = row
          next
        end
        attributes = ActiveSupport::HashWithIndifferentAccess.new(Hash[fields.zip(row)])
        record = if id = attributes['id']
                   self.where(id: id).first_or_initialize
                 else
                   self.new
                 end
        record.attributes = attributes
        if block_given?
          val = yield record, attributes
          next if val == false
        end
        record.save!
        records << record
      end
      records
    end
  end
end
