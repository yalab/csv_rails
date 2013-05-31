module CsvRails::Import
  extend ActiveSupport::Concern
  module ClassMethods
    def csv_import(body, opts={})
      fields = opts[:fields]
      records = []
      self.transaction do
        CSV.parse(body).each.with_index do |row, i|
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
            val = yield record, attributes, i
            next if val == false
          end
          record.save!
          records << record
        end
      end
      records
    end
  end
end
