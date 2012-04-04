require 'csv_rails/array'
require 'csv_rails/active_model'

Array.send(:include, CsvRails::Array)

if defined?(ActiveRecord)
  require 'csv_rails/active_record'
  ActiveRecord::Base.send(:include, CsvRails::ActiveRecord)
end

if defined?(Mongoid)
  require 'csv_rails/mongoid'
  Mongoid::Document.send(:include, CsvRails::Mongoid)
end

ActionController::Renderers.add :csv do |obj, options|
  filename = options[:filename] || File.basename(request.path)
  send_data obj.to_csv(options), :type => Mime::CSV,
  :disposition => "attachment; filename=#{filename}.csv"
end
