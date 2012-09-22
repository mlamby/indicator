# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 
require 'rake'
require 'rake/clean'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'lib' << 'test' << 'examples'
  t.test_files = FileList['test/**/*.rb']
  t.verbose = false
end
