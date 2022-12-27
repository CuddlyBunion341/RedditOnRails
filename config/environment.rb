# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

# Configure error messages to not wrap in a div
ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  html_tag.html_safe
end
