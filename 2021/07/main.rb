require "bundler/inline"

gemfile do
  source "https://rubygems.org"

  gem "minitest"
  gem "pry"
end

require "minitest/autorun"

class Day5Test < Minitest::Test
  def input
    "16,1,2,0,4,2,7,1,2,14"
  end

  def test_part1
    assert_equal 37, CrabAttack.parse(input, FixedFuelCost).cheapest_alignment_cost
  end

  def test_part2
    assert_equal 168, CrabAttack.parse(input, IncreasingFuelCost).cheapest_alignment_cost
  end
end

FixedFuelCost = Struct.new(:positions) do
  def cheapest_alignment
    size = positions.size
    sorted = positions.sort
    median = (sorted[(size - 1) / 2] + sorted[size / 2]) / 2.0
    sorted.map { |p| (p - median).abs }.sum
  end
end

IncreasingFuelCost = Struct.new(:positions) do
  def cheapest_alignment
    mean_ceil = (positions.sum / positions.size.to_f).ceil
    mean_floor = (positions.sum / positions.size.to_f).floor
    [
      positions.sum { |p| (0..(mean_ceil - p).abs).sum },
      positions.sum { |p| (0..(mean_floor - p).abs).sum },
    ].min
  end
end

CrabAttack = Struct.new(:positions, :calculator) do
  def self.parse(input, calculator)
    positions = input.split(",").map(&:to_i)
    new(positions, calculator)
  end

  def cheapest_alignment_cost
    calculator.new(positions).cheapest_alignment
  end
end

input = File.read(File.join(__dir__, "input.txt"))
puts "=" * 40
puts "Part1: #{CrabAttack.parse(input, FixedFuelCost).cheapest_alignment_cost}"
puts "Part2: #{CrabAttack.parse(input, IncreasingFuelCost).cheapest_alignment_cost}"
puts "=" * 40
