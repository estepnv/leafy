
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "leafy/version"

Gem::Specification.new do |spec|
  spec.name          = "leafy-ruby"
  spec.version       = Leafy.version
  spec.authors       = ["Evgeny Stepanov"]
  spec.email         = ["estepnv@icloud.com"]

  spec.summary       = %q{Toolkit for custom attributes in Ruby apps}
  spec.description   = <<-DESC
  Leafy is toolkit that allows you to integrate dynamic custom attributes functionality into your ruby application.

  It provides high level API you can use for any suitable use-case.
  It ships with several basic data types and allows you to add your own data type converters.
  DESC

  spec.homepage      = "https://gibhub.com/estepnv/leafy"
  spec.license       = "MIT"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "simplecov"

  if RUBY_VERSION >= "2.2.2"
    spec.add_development_dependency "activerecord", "~> 5.0"
  else
    spec.add_development_dependency "activerecord", "~> 4.2"
  end

  if RUBY_ENGINE == "jruby"
    spec.add_development_dependency "activerecord-jdbcsqlite3-adapter", "51"
  else
    spec.add_development_dependency "sqlite3"
  end
end
