# frozen_string_literal: true

require_relative "lib/active_crud/version"

Gem::Specification.new do |spec|
  spec.name = "active_crud"
  spec.version = ActiveCrud::VERSION
  spec.authors = ["Nishi Kant Sharma"]
  spec.email = ["nishi.enquiry@gmail.com"]

  spec.summary = "https://github.com/nishienquiry/active_crud"
  spec.description = "https://github.com/nishienquiry/active_crud"
  spec.homepage = "https://rubygems.org/gems/active_crud"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.5.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/nishienquiry/active_crud"
  spec.metadata["changelog_uri"] = "https://github.com/nishienquiry/active_crud"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'rails'
  spec.add_dependency 'will_paginate'
  spec.add_dependency 'ransack'

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
