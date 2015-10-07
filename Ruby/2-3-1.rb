# PCCB 2-3-1
# -*- coding: utf-8 -*-

module Solver
  @dp = [[]]

  def Solver.solve(items, sum)
    memo(items, 0, sum)
  end

  def Solver.memo(items, index, residual)
    return @dp[index][residual] if @dp[index] && @dp[index][residual]
    if not (0...items.size).include? index
      return 0
    else
      @dp[index] = Array.new if @dp[index] == nil
      item = items[index]
      if item[:weight] > residual
        return @dp[index][residual] = memo(items, index + 1, residual)
      else
        return @dp[index][residual] = choose(
            item[:value] + memo(items, index + 1, residual - item[:weight]),
            memo(items, index + 1, residual),
        )
      end
    end
  end

  def Solver.choose(l, r)
    l < r ? r : l
  end
end

sum   = 0
items = []

ARGV.each_with_index do |arg, index|
  begin
    if index == 0
      sum = Integer(arg)
      raise RangeError, "target summation must be greater than 0" if sum < 0
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

puts "result: %d" % Solver::solve(items, sum)
