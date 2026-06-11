## [1.0.0] - 2026-06-11

- Require Ruby >= 3.2, dropping end-of-life Ruby 3.1
- Update the development toolchain to Ruby 3.4, Rails 8.0, RSpec 3.13, rspec-rails 7.0, and the latest RuboCop
- Replace the `byebug` development dependency with `debug`
- Run the RSpec suite as part of the default Rake task (and in CI), not just RuboCop
- Load the dummy app's schema automatically when running the suite
- Share a single Gemfile between the gem and its dummy test app
- Refresh the bundle for current platforms (Apple Silicon and Linux)
- Replace the boilerplate README with real installation and usage instructions
- Add a Rails-free unit suite characterising `Record`, `Collection`, `Root`, and `UpstreamRecordFinder`, plus a `Loader` spec
- Depend on `factory_bot` and `activesupport` directly instead of `factory_bot_rails`, so the gem no longer pulls in a Railtie
- Refactor `Record#with` into a small classifier plus focused helpers, removing all of its RuboCop disables
- `Record#with(2, :racing_wheels)` (the plural of an STI child type) now works instead of raising "Unknown association"; the plural of a parentless singular now raises the clearer "Cannot create multiple of singular associations" error
- Include provided attributes in the output of `#to_plan` / `#build_plan`
- Show every association that was explicitly added in the build plan (including empty singular associations), rather than silently dropping empties
- Drop the unused `model`, `name`, and `traits` fields from loaded factory configurations

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
