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
        attributes = Hash[fields.zip(row)]
        object = if id = attributes['id']
                   self.where(id: id).first_or_create
                 else
                   self.new
                 end
        object.attributes = attributes
        object.save!
      end
    end
  end
end
