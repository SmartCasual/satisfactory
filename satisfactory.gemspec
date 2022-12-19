require_relative "lib/satisfactory/version"

Gem::Specification.new do |spec|
  spec.name = "satisfactory"
  spec.version = Satisfactory::VERSION
  spec.authors = ["Elliot Crosby-McCullough"]
  spec.email = ["elliot.cm@gmail.com"]

  spec.summary = "A DSL for navigating your factories and building test data"
  spec.homepage = "https://github.com/SmartCasual/satisfactory"

  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/v#{spec.version}/CHANGELOG.md"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  spec.metadata["rubygems_mfa_required"] = "true"
  spec.required_ruby_version = ">= 3.1.0"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "bin"
  spec.executables = spec.files.grep(%r{\Abin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "factory_bot_rails", "~> 6.2"

  spec.add_development_dependency "rubocop", "~> 1.40"
end
