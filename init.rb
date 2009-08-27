# Includes rwt module in rails application:
ActionController::Base.send :include, Rwt
I18n.load_path += Dir[File.dirname(__FILE__) + '/locale/**/*.yml']

Mime::Type.register "application/rwt", :rwt

puts "** Rwt actived"
