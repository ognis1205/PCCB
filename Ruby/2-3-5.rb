# -*- coding: utf-8 -*-
# PCCB 2-3-5

module Solver
  class Memo
    def initialize(sequence)
      @data = [Float::INFINITY] * sequence.size
      sequence.each do |value|
        position(value)
      end
    end

    def find_last_index(&b)
      @data.reverse.find_index &b
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
    memo = Memo::new(sequence)
    index = memo.find_last_index { |element| element != Float::INFINITY }
    index + 1
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
