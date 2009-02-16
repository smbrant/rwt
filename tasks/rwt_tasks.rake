EXTJS_VERSION = '2.2'

namespace :rwt do
  desc 'Install the ExtJs javascript library into the public/ext directory of this application'
  task :install_extjs => ['rwt:add_or_replace_extjs']

  desc 'Update the ExtJs javascript library into the public/ext directory of this application'
  task :update_extjs => ['rwt:add_or_replace_extjs']

  task :add_or_replace_extjs do
    require 'fileutils'
    dest = "#{RAILS_ROOT}/public/ext"
    if File.exists?(dest)
      # upgrade
      begin
        puts "Removing directory #{dest}..."
        FileUtils.rm_rf dest
        puts "Recreating directory #{dest}..."
        FileUtils.mkdir_p dest
        puts "Installing ExtJs version #{EXTJS_VERSION} to #{dest}..."
        FileUtils.cp_r "#{RAILS_ROOT}/vendor/plugins/rwt/assets/public/ext/.", dest
        puts "Successfully updated ExtJs to version #{EXTJS_VERSION}."
      rescue
        puts "ERROR: Problem updating ExtJs. Please manually copy "
        puts "#{RAILS_ROOT}/vendor/plugins/rwt/assets/public/ext"
        puts "to"
        puts "#{dest}"
      end
    else
      # install
      begin
        puts "Creating directory #{dest}..."
        FileUtils.mkdir_p dest
        puts "Installing ExtJs version #{EXTJS_VERSION} to #{dest}..."
        FileUtils.cp_r "#{RAILS_ROOT}/vendor/plugins/rwt/assets/public/ext/.", dest
        puts "Successfully installed ExtJs version #{EXTJS_VERSION}."
      rescue
        puts "ERROR: Problem installing ExtJs. Please manually copy "
        puts "#{RAILS_ROOT}/vendor/plugins/rwt/assets/public/ext"
        puts "to"
        puts "#{dest}"
      end
    end
  end
end
