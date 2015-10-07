# PCCB 2-3-5
# -*- coding: utf-8 -*-

module Solver
  class Memo
    def initialize(sequence)
      @data = [Float::INFINITY] * sequence.size
      sequence.each do |value|
        position(value)
      end
    end

    def longest_subsequence
      @data.size - @data.reverse.find_index { |element| element != Float::INFINITY }
    end

    def position(value)
      left = 0
      right = @data.size - 1

      while left < right
        mid = (left + right) / 2
        if value <= @data[mid]
          right = mid
        else
          left = mid + 1
        end
      end

      @data[right] = value
    end
  end

  def Solver::solve(sequence)
    Memo::new(sequence).longest_subsequence
  end
end

sequence = []

ARGV.each_with_index do |arg, index|
  begin
    sequence << Integer(arg)
  rescue Exception => e
    puts e.to_s
    exit
  end
end

puts "result: %d" % Solver::solve(sequence)
