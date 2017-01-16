# TablePuts
[![Gem Version](https://badge.fury.io/rb/table_puts.svg)](https://badge.fury.io/rb/table_puts)

Print nice tables in a ruby console

# Installation
```ruby
# Install as a standalone gem
$ gem install table_puts

# Or with bundler
gem "table_puts" # In your Gemfile
$ bundle install
```

# Usage

### Array of Hashes
```ruby
TablePuts.call(data)
```
TablePuts prints data that is in the form of an array of hashes all with the same keys

For example:

```ruby
[ { title: 'Super Mario Bros', release_year: 1985 },
  { title: 'Sonic the Hedgehog', release_year: 1991 }]
```

would print as

```
+--------------------+--------------+
| title              | release_year |
+--------------------+--------------+
| Super Mario Bros   |         1985 |
| Sonic the Hedgehog |         1991 |
+--------------------+--------------+
```

### CSV
You can also pass in the path to a CSV file:
```ruby
TablePuts.csv('path/to/your.csv')
```
# Configuration
Both `TablePuts.call` and `TablePuts.csv` take optional parameters `min_width` and `max_width` that sets the minimum and maximum allowed character widths of each column.

```ruby
TablePuts.call(data, min_width: 10, max_width: 15)
```

By default `min_width` is `0` and `max_width` is `20`. You can change these defaults in a configuration block.

```ruby
TablePuts.configuration do |config|
  config.min_column_width = # new minimum default
  config.max_column_width = # new maximum default
end
```
