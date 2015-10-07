# PCCB 1-6-2
# -*- coding: utf-8 -*-

class Solver
  def self.solve(length, ants)
    max = nil
    min = nil
    for ant in ants do
      candidate = MAX(length - ant, ant)
      max = max != nil && max > candidate ? max : candidate
      min = min != nil && min < candidate ? min : candidate
    end
    puts "max: #{max}"
    puts "min: #{min}"
  end

  def self.MAX(l, r)
    return l if l > r
    return r
  end
end

$length = 0
$ants   = []

ARGV.each_with_index do |arg, index|
  begin
    if index == 0
      $length = Integer(arg)
    else
      $ants  << Integer(arg)
    end
  rescue Exception => e
    puts e.to_s
    exit
  end
end

Solver.solve($length, $ants)
