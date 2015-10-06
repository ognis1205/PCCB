# -*- coding: utf-8 -*-
# PCCB 2-3-2

module Solver
  class Memo
    attr_reader :data

    def initialize
      @data = [[]]
    end

    def [](i, j)
      @data[i] = Array::new if not @data[i]
      @data[i][j]
    end

    def []=(i, j, data)
      @data[i] = Array::new if not @data[i]
      @data[i][j] = data
    end
  end

  def Solver::solve(items, constraint)
    @memo = Memo::new
    @items = items
    @constraint = constraint
    memoize(items.size, constraint)
  end

  def Solver::memoize(i, j)
    @memo[i, j] if @memo[i, j] != nil
    if i == 0 and j == 0
      @memo[i, j] = 0
    elsif i == 0 and j != 0
      @memo[i, j] = Float::INFINITY
    elsif @items[i - 1][:value] <= j
      @memo[i, j] = min(memoize(i - 1, j), memoize(i - 1, j - @items[i - 1][:value]) + @items[i - 1][:weight])
    else
      @memo[i, j] = memoize(i - 1, j)
    end
  end

  def Solver::min(left, right)
    left < right ? left : right
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
