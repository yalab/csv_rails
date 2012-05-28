require 'csv'
module CsvRails
  module Array
    def self.included(base)
      base.send(:remove_method, :to_csv)
    end

    # ==== Options
    # * <tt>:fields</tt> - target field names
    # * <tt>:header</tt> - header
    # * <tt>:without_header</tt> - total_count
    # * <tt>:encoding</tt> - encoding
    # * <tt>:i18n_scope</tt> - i18n scope

    def separated_values(sep, opts)
      klass = first.class
      fields = if opts[:fields]
                 opts.delete(:fields)
               elsif klass.respond_to?(:csv_fields)
                 klass.csv_fields
               else
                 []
               end

      header = if opts[:header]
                 opts.delete(:header)
               elsif klass.respond_to?(:csv_header)
                 klass.csv_header(fields, opts.delete(:i18n_scope))
               else
                 scopes = ['csv_rails']
                 scopes << opts[:i18n_scope] if opts[:i18n_scope]
                 fields.map{|f|
                   defaults = scopes.map{|s| "#{s}.#{f}".to_sym }.push(f.to_s)
                   I18n.t(defaults.shift, :default => defaults)
                 }
               end
      csv = CSV.generate(:col_sep => sep) do |_csv|
        _csv << header if header && !opts[:without_header]
        each do |element|
          _csv << element.to_csv_ary(fields, opts)
        end
      end
      opts[:encoding] ? csv.encode(opts[:encoding]) : csv
    end

    def to_csv(opts={})
      separated_values(",", opts)
    end

    def to_tsv(opts={})
      "sum\tmax"
    end
  end
end
