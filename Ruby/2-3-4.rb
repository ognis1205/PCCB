# PCCB 2-3-4
# -*- coding: utf-8 -*-

module Solver
  class Memo
    def initialize(items=[], constraint=0)
      @data = [[]]
      @items = items
      @constraint = constraint
    end

    class << Array
      def inject(acc, &b)
        return acc if empty?
        (drop 1).inject(yield(acc, first), &b)
      end
    end

    def [](i, j)
      @data[i] = Array::new if not @data[i]
      @data[i][j] if @data[i][j] != nil
      if i == 0 and j == 0
        @data[i][j] = 0
      elsif i == 0 and j != 0
        @data[i][j] = Float::INFINITY
      elsif @items[i - 1][:value] <= j
        @data[i][j] = Memo::min(self[i - 1, j], self[i - 1, j - @items[i - 1][:value]] + @items[i - 1][:weight])
      else
        @data[i][j] = self[i - 1, j]
      end
    end

    private

    def Memo::min(left, right)
      left < right ? left : right
    end
  end

  def Solver::solve(items, constraint)
    memo = Memo::new(items, constraint)
    sup = items.inject(0) { |acc, item| acc += item[:value]}
    answer = 0
    (0..sup).each do |candidate|
      answer = memo[items.size, candidate] > constraint ? answer : candidate
    end
    answer
  end
end

constraint = 0
items = []

ARGV.each_with_index do |arg, index|
  begin
    if index == 0
      constraint = Integer(arg)
      raise RangeError, "summation must be greater than 0" if constraint <= 0
    else
      weight, value = arg.split(',')
      weight = Integer(weight)
      value  = Integer(value)
      if weight && weight > 0 && value && value > 0
        items << { weight: weight, value: value }
      end
    end
  rescue Exception => e
    puts e.to_s
    exit
  end
end

puts "result: %d" % Solver::solve(items, constraint)
