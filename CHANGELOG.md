## [Unreleased]

- Require Ruby >= 3.2, dropping end-of-life Ruby 3.1
- Update the development toolchain to Ruby 3.4, Rails 8.0, RSpec 3.13, rspec-rails 7.0, and the latest RuboCop
- Replace the `byebug` development dependency with `debug`
- Run the RSpec suite as part of the default Rake task (and in CI), not just RuboCop
- Load the dummy app's schema automatically when running the suite
- Share a single Gemfile between the gem and its dummy test app
- Refresh the bundle for current platforms (Apple Silicon and Linux)
- Replace the boilerplate README with real installation and usage instructions
- Add a Rails-free unit suite characterising `Record`, `Collection`, `Root`, and `UpstreamRecordFinder`, plus a `Loader` spec

## [0.3.2] - 2023-01-24

- Add some missing proxy methods

## [0.3.1] - 2023-01-18

- Fix associations bug

## [0.3.0] - 2022-12-22

- Fix some API inconsistencies
- Add a starter acceptance test (with dummy Rails application)

## [0.2.1] - 2022-12-19

- Fix a clashing executable name by not packaging any

## [0.2.0] - 2022-12-19

- Main functionality implemented
- Documentation added
- Licence added

## [0.1.0] - 2022-12-09

- Initial release
