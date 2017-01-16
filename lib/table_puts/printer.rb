class TablePuts::Printer
  attr_reader :data, :transposed, :min_width, :max_width

  def initialize(data, min_width, max_width)
    @data = data
    @transposed = transpose_data
    @min_width = min_width
    @max_width = max_width
    check_widths(min_width, max_width)
  end

  def call
    puts break_string
    puts header
    puts break_string
    puts rows
    puts break_string
  end

  # Transforms data into a single hash with each value containing an array of
  # the values from each hash - for example:
  #
  # [ { x: 1, y: 2 }, { x: 3 }, { y: 4 } ]
  # becomes
  # { x: [1, 3], y: [2, 4] }
  #
  def transpose_data
    transposed_data = {}
    data.first.keys.map { |key| transposed_data[key] = [] }

    data.each do |hash|
      hash.each do |key,value|
        transposed_data[key] << value
      end
    end
    transposed_data
  end

  def header
    transposed.keys.map.with_index do |key, i|
      key_string = abbreviate(key.to_s).ljust(column_widths[i])

      "| #{ key_string } "
    end.join + "|"
  end

  def rows
    justification = calculate_column_justification
    data.map do |row|
      row.map.with_index do |(key, value), i|
        justify = "#{ justification[i] }just".to_sym
        value_string = abbreviate(value.to_s).send(justify, (column_widths[i]))

        "| #{ value_string } "
      end.join + "|"
    end
  end

  def break_string
    @break_string ||= column_widths.map { |size| "+-#{ '-'*size }-" }.join + "+"
  end

  # An array of how many characters wide each column should be
  #
  # You can set a minimum and maximum width for all columns
  # by passing in min_width and max_width
  def column_widths
    @column_widths ||= transposed.map do |value_array|
      largest_width_in_column = value_array.flatten.map { |entry| entry.to_s.length }.max
      [[largest_width_in_column, max_width].min, min_width].max
    end
  end

  # Computes how we should justify the values in each column
  #
  # If all values in a column contain a number or are nil, then we right justify
  # Otherwise, left justify
  #
  # Returns an array of 'r's and 'l's for each column
  def calculate_column_justification
    transposed.map do |(key, values)|
      values.all? { |entry| entry.to_s.match(/\d/) || entry.nil? } ? 'r' : 'l'
    end
  end

  def abbreviate(string)
    string == string[0...max_width] ? string : string[0...max_width-3] + "..."
  end

  def check_widths(min, max)
    if min > max
      puts "WARNING: max_width is greater than min_width"
      puts "         This may cause unexpected output"
      puts "         min_width: #{ min_width }\tmax_width: #{ max_width }"
    end
  end
end
