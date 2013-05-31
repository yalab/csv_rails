module CsvRails::Import
  extend ActiveSupport::Concern
  module ClassMethods
    def csv_import(body, opts={})
      fields = opts[:fields]
      objects = []
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
        if block_given?
          val = yield object, attributes
          next if val == false
        end
        object.save!
        objects << object
      end
      objects
    end
  end
end
