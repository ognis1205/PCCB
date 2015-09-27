# -*- coding: utf-8 -*-
# PCCB 2-1-1

class Solver
  def self.solve(sum, array)
    dfs(sum, 0, array)
  end

  def self.dfs(residual, index, array, accumulator=[])
    if residual == 0
      puts "found: #{accumulator}"
      return
    elsif index >= array.size
      return
    end
    accumulator.push(index)
    dfs(residual - array[index], index + 1, array, accumulator) if residual >= array[index]
    accumulator.pop
    dfs(residual,                index + 1, array, accumulator)
  end
end

$sum   = 0
$array = []

ARGV.each_with_index do |arg, index|
  begin
    if index == 0
      $sum    = Integer(arg)
    else
      $array << Integer(arg)
    end
  rescue Exception => e
    puts e.to_s
    exit
  end
end

Solver.solve($sum, $array)