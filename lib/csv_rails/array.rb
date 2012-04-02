require 'csv'
module CsvRails
  module Array
    def self.included(base)
      base.send(:remove_method, :to_csv)
      base.send(:include, CsvRails::Array::InstanceMethods)
    end

    module InstanceMethods
      # ==== Options
      # * <tt>:fields</tt> - target field names
      # * <tt>:header</tt> - header
      # * <tt>:without_header</tt> - total_count
      # * <tt>:encoding</tt> - encoding
      def to_csv(opts={})
        fields = opts[:fields]
        header = if opts[:header]
                   opts.delete(:header)
                 elsif (klass = first.class).respond_to?(:csv_fields)
                   klass.csv_fields
                 else
                   scopes = ['csv_rails']
                   scopes << opts[:i18n_scope] if opts[:i18n_scope]
                   fields.map{|f|
                     defaults = scopes.map{|s| "#{s}.#{f}".to_sym }.push(f.to_s)
                     I18n.t(defaults.shift, :default => defaults)
                   }
                 end
        csv = CSV.generate do |_csv|
          _csv << header unless opts[:without_header]
          each do |element|
            _csv << element.to_csv_ary(fields, opts)
          end
        end
        opts[:encoding] ? csv.encode(opts[:encoding]) : csv
      end
    end
  end
end
