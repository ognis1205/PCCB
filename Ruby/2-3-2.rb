# -*- coding: utf-8 -*-
# PCCB 2-3-2

module Solver
  @memo = [[]]

  def Solver.solve(str1, str2)
    prepare(str1, str2)
    @memo[str1.size - 1][str2.size - 1]
  end

  def Solver.prepare(str1, str2)
    (0...str1.size).each do |i|
      (0...str2.size).each do |j|
        @memo[i] = Array.new if not @memo[i]
        if i == 0
          @memo[i][j] = (str1.include? str2[j]) ? 1 : 0
        elsif j == 0
          @memo[i][j] = (str2.include? str1[i]) ? 1 : 0
        elsif str1[i] == str2[j]
          @memo[i][j] = @memo[i - 1][j - 1] + 1
        else
          @memo[i][j] = @memo[i][j - 1] > @memo[i - 1][j] ? @memo[i][j - 1] : @memo[i - 1][j]
        end
      end
    end
  end
end

str1 = ""
str2 = ""

if ARGV.size != 2
  raise ArgumentError, "exactly two strings must be supplied"
  exit
else
  str1 = ARGV[0]
  str2 = ARGV[1]
end

puts "result: %d" % Solver::solve(str1, str2)
