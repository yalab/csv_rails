require 'csv'
module CsvRails
  module ActiveModel
    module ClassMethods
      def to_csv(opts={})
        fields = opts[:fields] || csv_fields
        scope = opts.delete(:i18n_scope)
        header = fields.map{|f|
          if scope
            I18n.t("#{scope}.#{f}", :default => human_attribute_name(f))
          else
            human_attribute_name(f)
          end
        }
        all.to_a.to_csv(opts.update(:fields => fields, :header => header))
      end

      def csv_fields
        if respond_to?(:attribute_names)
          attribute_names
        elsif self.is_a?(::ActiveRecord::Relation)
          @klass.new.attribute_names
        else
          new.attribute_names
        end
      end
    end

    module InstanceMethods
      def to_csv_ary(fields=nil, opts={})
        fields = attribute_names unless fields
        fields.map{|field|
          field.to_s.split(".").inject(self){|object, f|
            next unless object
            convert_method = "#{f}_as_csv"
            method = object.respond_to?(convert_method) ? convert_method : f
            object.send(method)
          }
        }
      end
    end
  end
end
