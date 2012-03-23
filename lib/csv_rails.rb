require File.expand_path('../active_record/acts/csv', __FILE__)

ActiveRecord::Base.send(:include, ActiveRecord::Acts::Csv)
