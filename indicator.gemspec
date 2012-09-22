lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'indicator/version'

Gem::Specification.new do |s|
  s.name = 'indicator'
  s.version = Indicator::VERSION
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc', 'LICENSE']
  s.summary = 'Technical Analysis library'
  s.description = 'Higher level wrapper around the talib_ruby project'
  s.author = 'mrlamby'
  s.email = ''
  s.homepage = 'https://github.com/mlamby/indicator'
  # s.executables = ['your_executable_here']
  s.files = %w(LICENSE README.rdoc Rakefile) + Dir.glob("{lib,test,examples}/**/*")
  s.require_path = "lib"
  s.bindir = "bin"
  s.add_runtime_dependency 'talib_ruby'
end
