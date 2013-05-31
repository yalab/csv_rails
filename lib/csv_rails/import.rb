module CsvRails::Import
  extend ActiveSupport::Concern
  module ClassMethods
    def csv_import(body, opts={})
      fields = nil
      CSV.parse(body).each do |row|
        unless fields
          fields = row
          next
        end
        attributes = ActiveSupport::HashWithIndifferentAccess.new(Hash[fields.zip(row)])
        object = if id = attributes['id']
                   self.where(id: id).first_or_initialize
                 else
                   self.new
                 end
        object.attributes = attributes
        yield object, attributes if block_given?
        object.save!
      end
    end
  end
end
