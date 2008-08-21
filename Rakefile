# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

Rake::TestTask.new(:rwt) do |t|
   t.libs << "rwt"
   t.test_files = FileList['test/**/test*.rb']
   t.verbose = true
end