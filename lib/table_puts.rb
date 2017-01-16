module TablePuts
  require 'helpers/configuration'
  require 'table_puts/printer'
  require 'csv'
  extend Configuration

  # Set defaults for column width
  #
  # Can be changed by doing:
  # TablePuts.configuration do |config|
  #   config.min_column_width = 10
  # end
  define_setting(:min_column_width, 0)
  define_setting(:max_column_width, 20)

  # Takes in data in the form of an array of hashes all with the same keys
  # and prints a nice looking table
  def self.call(data, min_width: self.min_column_width, max_width: self.max_column_width)
    Printer.new(data, min_width, max_width).call
  end

  # Takes in the file path of a CSV and prints a nice looking table
  def self.csv(path, min_width: self.min_column_width, max_width: self.max_column_width)
    Printer.new(read_csv(path), min_width, max_width).call
  end

  private

  # Transforms CSV into an array of hashes
  def self.read_csv(path)
    csv_data = CSV.open(path).read
    keys = csv_data.shift
    csv_data.map { |items| items.map.with_index { |item, i| [keys[i], item] }.to_h }
  end
end
