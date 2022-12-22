require_relative "lib/satisfactory/version"

Gem::Specification.new do |spec|
  spec.name = "satisfactory"
  spec.version = Satisfactory::VERSION
  spec.authors = ["Elliot Crosby-McCullough"]
  spec.email = ["elliot.cm@gmail.com"]

  spec.summary = "A DSL for navigating your factories and building test data"
  spec.homepage = "https://github.com/SmartCasual/satisfactory"
  spec.license = "CC-BY-NC-SA-4.0"

  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/v#{spec.version}/CHANGELOG.md"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  spec.metadata["rubygems_mfa_required"] = "true"
  spec.required_ruby_version = ">= 3.1.0"

  spec.files = Dir.chdir(File.expand_path(__dir__)) {
    Dir[
      "lib/**/*",
      "CHANGELOG.md",
      "LICENCE",
      "README.md",
      "satisfactory.gemspec",
    ]
  }

  spec.require_paths = ["lib"]

  spec.add_dependency "factory_bot_rails", "~> 6.2"
end
