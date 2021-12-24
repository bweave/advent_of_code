require "bundler/inline"

gemfile do
  source "https://rubygems.org"

  gem "minitest"
  gem "pry"
end

require "minitest/autorun"

class Day8Test < Minitest::Test
  def input
    <<~TEST
      be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
      edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
      fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
      fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
      aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
      fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
      dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
      bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
      egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
      gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
    TEST
  end

  def test_part1
    assert_equal 26, SevenSegmentDisplay.parse(input).unique_number_count
  end

  def test_part2
    skip
  end
end
SevenSegmentDisplay = Struct.new(:four_digit_outputs) do
  NUMBERS_TO_SEGMENTS = {
    1 => 2,
    2 => 5,
    3 => 5,
    4 => 4,
    5 => 5,
    6 => 6,
    7 => 3,
    8 => 7,
    9 => 6,
  }.freeze

  def self.parse(input)
    four_digit_outputs = input.split("\n").map do |line|
      _signal_patterns, four_digit_output = line.split(" | ")
      four_digit_output
    end
    new(four_digit_outputs)
  end

  def unique_number_count
    unique_segment_count_numbers = [1, 4, 7, 8]

    sizes_tally = four_digit_outputs.reduce(Hash.new(0)) do |acc, output|
      output.split.map(&:size).each { |size| acc[size] += 1 }
      acc
    end

    sizes_tally.values_at(*NUMBERS_TO_SEGMENTS.values_at(*unique_segment_count_numbers)).sum
  end
end

input = File.read(File.join(__dir__, "input.txt"))
puts "=" * 40
puts "Part1: #{SevenSegmentDisplay.parse(input).unique_number_count}"
puts "=" * 40
