# -*- coding: utf-8 -*-
# PCCB 2-3-3

module Solver
  class Memo
    def initialize
      @data = [[]]
    end

    def [](i, j)
      @data[i] = Array.new if @data[i] == nil
      @data[i][j]
    end

    def []=(i, j, data)
      @data[i] = Array.new if @data[i] == nil
      @data[i][j] = data
    end
  end

  @memo = Memo.new

  def Solver::solve(items, constraint)
    prepare(items, constraint)
    @memo[items.size-1, constraint]
  end

  def Solver::prepare(items, constraint)
    (0..items.size-1).each do |i|
      (0..constraint).each do |j|
        if i == 0
          number = j / items[i][:weight]
          @memo[i, j] = number * items[i][:value]
        else
          if j >= items[i][:weight]
            @memo[i, j] = max(@memo[i-1, j], @memo[i-1, j-items[i][:weight]] + items[i][:value])
          else
            @memo[i, j] = @memo[i-1, j]
          end
        end
      end
    end
  end

  def Solver::max(left, right)
    left > right ? left : right
  end
end

constraint = 0
items      = []

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
