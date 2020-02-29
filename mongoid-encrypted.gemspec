
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "mongoid/encrypted/version"

Gem::Specification.new do |spec|
  spec.name          = "mongoid-encrypted"
  spec.version       = Mongoid::Encrypted::VERSION
  spec.authors       = ["Matt Duffy"]
  spec.email         = ["mttdffy@gmail.com"]

  spec.summary       = %q{Encrypt mongoid fields with Rails encryption.}
  spec.homepage      = "https://github.com/workarea-commerce/mongoid-encrypted"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.require_paths = ["lib"]

  spec.add_dependency 'activesupport', '>= 5.2.0'
  spec.add_dependency 'mongoid', '>= 6.4.0'

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
