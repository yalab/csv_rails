require 'csv_rails/array'
require 'csv_rails/active_record'

ActiveRecord::Base.send(:include, CsvRails::ActiveRecord)
Array.send(:include, CsvRails::Array)

ActionController::Renderers.add :csv do |obj, options|
  filename = options[:filename] || File.basename(request.path)
  send_data obj.to_csv(options), :type => Mime::CSV,
  :disposition => "attachment; filename=#{filename}.csv"
end
