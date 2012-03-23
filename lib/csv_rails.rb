require File.expand_path('../active_record/acts/csv', __FILE__)
require File.expand_path('../csv_rails/array', __FILE__)
ActiveRecord::Base.send(:include, ActiveRecord::Acts::Csv)
Array.send(:include, CsvRails::Array)

ActionController::Renderers.add :csv do |obj, options|
  filename = options[:filename] || File.basename(request.path)
  send_data obj.to_csv(options), :type => Mime::CSV,
  :disposition => "attachment; filename=#{filename}.csv"
end
