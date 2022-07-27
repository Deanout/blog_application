# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

Rails.logger = Logger.new("log/#{Rails.env}.log")
Rails.logger.level = Logger::INFO

Rails.logger.datetime_format = '%Y-%m-%d %H:%M:%S'
Rails.logger.formatter = proc do |severity, datetime, progname, msg|
  "|#{datetime}|#{severity}|#{progname}|#{msg}\n"
end
Rails.logger.info("Environment: #{Rails.env}") do
  'Started The Rails App!'
end
