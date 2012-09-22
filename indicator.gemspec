lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'indicator/version'

Gem::Specification.new do |s|
  s.name = 'indicator'
  s.version = Indicator::VERSION

  s.summary = 'Technical Analysis library'
  s.description = 'Higher level wrapper around the talib_ruby project'
  s.author = 'Michael Lamb'
  s.email = 'mr.lamby@gmail.com'
  s.platform = Gem::Platform::Ruby
  s.homepage = 'https://github.com/mlamby/indicator'
  s.files = %w(LICENSE LICENSE-ta-lib README.rdoc Rakefile) + Dir["{lib,examples}/**/*"]
  s.test_files = Dir["test/**/*"]

  s.add_runtime_dependency 'talib_ruby'

end
