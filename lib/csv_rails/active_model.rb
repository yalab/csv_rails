require 'csv'
module CsvRails
  module ActiveModel
    module ClassMethods
      def to_csv(opts={})
        fields = opts[:fields] || csv_fields
        header = csv_header(fields, opts.delete(:i18n_scope))
        all.to_a.to_csv(opts.update(:fields => fields, :header => header))
      end

      def csv_header(fields, scope=nil)
        fields.map{|f|
          if scope
            I18n.t("#{scope}.#{f}", :default => human_attribute_name(f))
          else
            human_attribute_name(f)
          end
        }
      end

      def csv_fields
        if self.is_a?(::ActiveRecord::Relation)
          @klass.attribute_names
        else
          attribute_names
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
