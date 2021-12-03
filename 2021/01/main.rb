require "bundler/inline"

gemfile do
  source "https://rubygems.org"

  gem "minitest"
  gem "pry"
end

require "minitest/autorun"

class Day1Test < Minitest::Test
  def input
    <<~TEST
      180
      152
      159
      171
      178
      169
      212
    TEST
  end

  def test_part1
    result = Part1.new(input).call
    assert_equal 4, result
  end

  def test_part2
    result = Part2.new(input).call
    assert_equal 3, result
  end
end

class Part1
  def initialize(input)
    @input = input.split.map(&:to_i)
    @increases = 0
  end

  def call
    @input.each_cons(2) do |(first, second)|
      @increases += 1 if second > first
    end

    @increases
  end
end

class Part2
  def initialize(input)
    @input = input.split.map(&:to_i)
    @increases = 0
  end

  def call
    @input.each_cons(3).map(&:sum).each_cons(2) do |(first, second)|
      @increases += 1 if second > first
    end

    @increases
  end
end

input = File.read("inputs.txt")
puts "part1: #{Part1.new(input).call}"
puts "part2: #{Part2.new(input).call}"
