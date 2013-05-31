require 'csv_rails/array'
require 'csv_rails/active_model'
require 'csv_rails/import'

Array.send(:include, CsvRails::Array)

if defined?(ActiveRecord)
  require 'csv_rails/active_record'
  ActiveRecord::Base.send(:include, CsvRails::ActiveRecord)
end

if defined?(Mongoid)
  require 'csv_rails/mongoid'
  Mongoid::Document.send(:include, CsvRails::Mongoid)
end

Mime::Type.register "text/tsv", :tsv

[:csv, :tsv].each do |format|
  ActionController::Renderers.add format do |obj, options|
    filename = options[:filename] || File.basename(request.path)
    send_data obj.send("to_#{format}", options), :type => Mime.const_get(format.to_s.upcase),
    :disposition => "attachment; filename=#{filename}.#{format}"
  end
end

