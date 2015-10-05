# -*- coding: utf-8 -*-
# PCCB 2-2-3

module Solver
  def Solver.solve(input)
    input  = String(input);
    output = String::new
    left = 0; right = input.size - 1

    while left <= right
      i = 0
      select_left = false
      while left + i < right
        if input[left + i] < input[right - i]
          select_left = true
          break
        elsif input[left + i] > input[right - i]
          select_left = false
          break
        end
        i += 1
      end
      if select_left
        output << input[left]
        left += 1
      else
        output << input[right]
        right -= 1
      end
    end

    output
  end
end

input = ""

ARGV.each_with_index do |arg, index|
  if index == 0
    input = arg
  end
end

puts "result: %s" % Solver.solve(input)
