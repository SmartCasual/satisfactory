# Satisfactory

Satisfactory is a factory library for Ruby that helps you navigate your factory
associations and build trees of test data with a fluent, readable DSL.

It is currently implemented on top of
[FactoryBot](https://github.com/thoughtbot/factory_bot), but could be extended to
support other factory libraries.

## Installation

Install the gem and add it to the application's Gemfile by executing:

```sh
bundle add satisfactory
```

If bundler is not being used to manage dependencies, install the gem by executing:

```sh
gem install satisfactory
```

Satisfactory reads your existing FactoryBot factories. Only factories whose model
inherits from `ApplicationRecord` are picked up.

## Usage

Start from the root and describe the tree of records you want, then call `create`
to build it (or `to_plan` to inspect what would be built):

```ruby
Satisfactory.root
  .add(:candidate, email_address: "sample@example.com")
  .with(:application_form).which_is(:submitted)
  .with(:application_choice)
  .and(2, :application_choices)
  .each_with(:course_option).which_is(:part_time)
  .and_same(:candidate)
  .with(:application_form, first_name: "Jane")
  .with(:application_choice).which_is(:rejected)
  .create
```

### The DSL

- `Satisfactory.root` — the entry point into the factory graph.
- `add(:factory, **attributes)` — add a top-level record to the root.
- `with(count = nil, :association, **attributes)` — add an associated record (or
  `count` of them for plural associations) to the current record.
- `with_new(count = nil, :association, **attributes)` — like `with`, but always
  creates a new record rather than reusing an existing one.
- `and(count = nil, :association, **attributes)` — add a sibling record to the
  current record's parent (e.g. a second `application_form` on the same candidate).
- `which_is(*traits)` / `which_are(*traits)` — apply one or more FactoryBot traits
  to the current record(s).
- `each_with(...)` / `which_are(...)` — operate on every record in a collection.
- `and_same(:type)` (aliased as `return_to`) — walk back up the tree to the nearest
  ancestor of the given type to continue building from there.
- `create` — build the whole tree and persist it. Returns the created records.
- `to_plan` — return a hash describing what would be built, without persisting.

## Development

After checking out the repo, run `bin/setup` to install dependencies.

The test suite exercises a dummy Rails application backed by PostgreSQL, so you'll
need a running PostgreSQL server. Create the test database once with:

```sh
createdb satisfactory_dummy_test
```

Then run the default task, which runs both the specs and RuboCop:

```sh
bin/rake
```

You can also run them individually with `bin/rspec` and `bin/rubocop`, or open an
interactive prompt with `bin/console`.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push git
commits and the created tag, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/SmartCasual/satisfactory.

## Licence

Released under the [CC-BY-NC-SA-4.0](LICENCE) licence.

