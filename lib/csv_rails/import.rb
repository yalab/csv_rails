# -*- coding: utf-8 -*-
module CsvRails::Import
  extend ActiveSupport::Concern
  module ClassMethods
    def inverse_human_attriute_name(attribute, options = {})
      defaults  = options[:defaults] || []
      parts     = attribute.to_s.split(".")
      attribute = parts.pop
      namespace = parts.join("/") unless parts.empty?

      if defaults.blank?
        if namespace
          lookup_ancestors.each do |klass|
            defaults << :"#{self.i18n_scope}.attributes.#{klass.model_name.i18n_key}/#{namespace}"
          end
          defaults << :"#{self.i18n_scope}.attributes.#{namespace}"
        else
          lookup_ancestors.each do |klass|
            defaults << :"#{self.i18n_scope}.attributes.#{klass.model_name.i18n_key}"
          end
        end
        defaults << :"attributes"
      end
      entry = nil
      defaults.each do |k|
        map = I18n.translate(k)
        if map.is_a?(Hash)
          entry = map.invert[attribute]
          break
        end
      end
      entry || attribute.underscore.gsub(/ /, '_')
    end

    def csv_import(body, opts={})
      fields = opts.delete(:fields)
      records = []
      all_green = true
      translated = false
      self.transaction do
        CSV.parse(body, opts).each.with_index do |row, i|
          unless fields
            fields = row
            next
          end
          unless translated
            fields.map!{|f| inverse_human_attriute_name(f)  }
            translated = true
          end
          attributes = ActiveSupport::HashWithIndifferentAccess.new(Hash[fields.zip(row)])
          record = if id = attributes['id']
                     self.where(id: id).first_or_initialize
                   else
                     self.new
                   end
          record.attributes = attributes.select{|k, v| self.attribute_method?(k) }
          if block_given?
            val = yield record, attributes, i
            next if val == false
          end
          if all_green && record.valid?
            record.save!
          else
            all_green = false
          end
          records << record
        end
        raise ActiveRecord::Rollback unless all_green
      end
      records
    end

    def tsv_import(body, opts={}, &block)
      csv_import(body, opts.merge(col_sep: "\t"), &block)
    end
  end
end
