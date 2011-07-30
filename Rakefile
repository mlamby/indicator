# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 
require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/testtask'
$: << File.join(File.expand_path(File.dirname(__FILE__)), "lib")
require 'indicator'

APP_BASE = File.dirname(File.expand_path(__FILE__))

spec = Gem::Specification.new do |s|
  s.name = 'indicator'
  s.version = Indicator::VERSION
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc', 'LICENSE']
  s.summary = 'Technical Analysis library'
  s.description = s.summary
  s.author = 'mrlamby'
  s.email = ''
  # s.executables = ['your_executable_here']
  s.files = %w(LICENSE README.rdoc Rakefile) + Dir.glob("{lib,test,examples}/**/*")
  s.require_path = "lib"
  s.bindir = "bin"
end

Rake::GemPackageTask.new(spec) do |p|
  p.gem_spec = spec
  p.need_tar = true
  p.need_zip = true
end

Rake::RDocTask.new do |rdoc|
  files =['README.rdoc', 'LICENSE', 'lib/**/*.rb']
  rdoc.rdoc_files.add(files)
  rdoc.main = "README.rdoc" # page to start on
  rdoc.title = "indicator Docs"
  rdoc.rdoc_dir = 'doc/rdoc' # rdoc output folder
  rdoc.options << '--line-numbers'
end

Rake::TestTask.new do |t|
  t.libs << 'lib' << 'test' << 'examples'
  t.test_files = FileList['test/**/*.rb']
  t.verbose = false
end
