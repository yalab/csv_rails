require 'csv_rails/array'
require 'csv_rails/active_model'

Array.send(:include, CsvRails::Array)

if defined?(ActiveRecord)
  ActiveRecord::Base.send(:include, CsvRails::ActiveModel)
  ActiveRecord::Relation.send(:include, CsvRails::ActiveModel::ClassMethods)
end

if defined?(Mongoid)

end

ActionController::Renderers.add :csv do |obj, options|
  filename = options[:filename] || File.basename(request.path)
  send_data obj.to_csv(options), :type => Mime::CSV,
  :disposition => "attachment; filename=#{filename}.csv"
end
