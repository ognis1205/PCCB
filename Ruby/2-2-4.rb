# -*- coding: utf-8 -*-
# PCCB 2-2-4

module Solver
  def Solver.solve(points, radius)
    result = 0
    while points.size > 0
      result += 1
      first_walk!(points, radius)
      second_walk!(points, radius)
    end
    result
  end

  def Solver.first_walk!(points, radius)
    criteria = points.first
    while points.size > 0
      if (points.first-radius..points.first).include? criteria
        points.shift
      else
        break
      end
    end
  end

  def Solver.second_walk!(points, radius)
    criteria = points.first
    while points.size > 0
      if (criteria..criteria+radius).include? points.first
        points.shift
      else
        break
      end
    end
  end
end

radius = 0
points = []

ARGV.each_with_index do |arg, index|
  begin
    if index == 0
      radius = Integer(arg)
    else
      points << Integer(arg)
    end
  rescue Exception => e
    puts e.to_s
    exit
  end
end

points.sort_by! { |l, r| l <=> r }
puts "result: %d" % Solver::solve(points, radius)
