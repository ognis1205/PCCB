# -*- coding: utf-8 -*-
# PCCB 2-3-2

module Solver
  @dp = [[]]

  def Solver.solve(str1, str2)
    prepare(str1, str2)
    @dp[str1.size - 1][str2.size - 1]
  end

  def Solver.prepare(str1, str2)
    (0...str1.size).each do |i|
      (0...str2.size).each do |j|
        @dp[i] = Array.new if not @dp[i]
        if i == 0
          @dp[i][j] = (str1.include? str2[j]) ? 1 : 0
        elsif j == 0
          @dp[i][j] = (str2.include? str1[i]) ? 1 : 0
        elsif str1[i] == str2[j]
          @dp[i][j] = @dp[i - 1][j - 1] + 1
        else
          @dp[i][j] = @dp[i][j - 1] > @dp[i - 1][j] ? @dp[i][j - 1] : @dp[i - 1][j]
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
