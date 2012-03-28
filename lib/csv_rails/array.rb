require 'csv'
module CsvRails
  module Array
    def self.included(base)
      base.send(:remove_method, :to_csv)
      base.send(:include, CsvRails::Array::InstanceMethods)
    end

    module InstanceMethods
      def to_csv(opts={})
        fields = opts[:fields]
        header = if opts[:header]
                   opts.delete(:header)
                 elsif (klass = first.class).respond_to?(:csv_header)
                   klass.csv_header(fields)
                 else
                   fields
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
