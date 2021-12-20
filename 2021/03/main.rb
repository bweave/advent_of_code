require "bundler/inline"

gemfile do
  source "https://rubygems.org"

  gem "minitest"
  gem "pry"
end

require "minitest/autorun"

class Day3Test < Minitest::Test
  def input
    <<~TEST
      00100
      11110
      10110
      10111
      10101
      01111
      00111
      11100
      10000
      11001
      00010
      01010
    TEST
  end

  def test_part1_gamma_rate
    assert_equal 22, Part1.new(input).gamma_rate
  end

  def test_part1_epsilon_rate
    assert_equal 9, Part1.new(input).epsilon_rate
  end

  def test_part1_power_consumption
    assert_equal 198, Part1.new(input).power_consumption
  end

  def test_part2_oxygen_generator_rating
    assert_equal 23, Part1.new(input).oxygen_generator_rating
  end

  def test_part2_c02_scrubber_rating
    assert_equal 10, Part1.new(input).c02_scrubber_rating
  end

  def test_part2_life_support_rating
    assert_equal 230, Part1.new(input).life_support_rating
  end
end

class Part1
  attr_reader :input, :columns

  def initialize(input)
    @input = input.split("\n")
    @columns = @input.map(&:chars).transpose
  end

  def power_consumption
    gamma_rate * epsilon_rate
  end

  def life_support_rating
    oxygen_generator_rating * c02_scrubber_rating
  end

  def gamma_rate
    columns.map(&method(:most_occurring)).join.to_i(2)
  end

  def epsilon_rate
    columns.map(&method(:least_occurring)).join.to_i(2)
  end

  def oxygen_generator_rating
    columns.size.times.reduce(input) do |acc, column_index|
      chars = acc.map { |a| a[column_index] }
      keeper = most_occurring(chars)
      acc.select { |a| a[column_index] == keeper }
    end.first.to_i(2)
  end

  def c02_scrubber_rating
    columns.size.times.reduce(input) do |acc, column_index|
      chars = acc.map { |a| a[column_index] }
      keeper = least_occurring(chars)
      acc.select { |a| a[column_index] == keeper }
    end.first.to_i(2)
  end

  private

  def most_occurring(chars)
    tally = chars.tally.invert
    tally[tally.keys.max]
  end

  def least_occurring(chars)
    tally = chars.tally.invert
    tally[tally.keys.min]
  end
end

input = File.read(File.join(__dir__, "input.txt"))
puts "=" * 40
puts "Part1: #{Part1.new(input).power_consumption}"
puts "Part2: #{Part1.new(input).life_support_rating}"
puts "=" * 40
