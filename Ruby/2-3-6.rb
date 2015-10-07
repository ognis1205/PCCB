# PCCB 2-3-6
# -*- coding: utf-8 -*-

module Solver
  class Memo
    def initialize(m, n)
      @data = [[nil] * (n + 1)] * (m + 1)
    end

    def [](i, j)
      return @data[i][j] if @data[i][j] != nil
      if i == 0
        @data[i][j] = j == 0 ? 1 : 0
      elsif i > j
        @data[i][j] = self[i - 1, j]
      else
        @data[i][j] = self[i, j - i] + self[i - 1, j]
      end
    end
  end

  def Solver::solve(n, m, l)
    memo = Memo::new(m, n)
    memo[m, n] % l
  end
end

begin
  if ARGV.size != 3
    raise ArgumentError, "ruby 2-3-7.rb <n> <m> <l>"
  else
    n = Integer(ARGV[0])
    m = Integer(ARGV[1])
    l = Integer(ARGV[2])
    raise ArgumentError, "n must be greater than 0" if n <= 0
    raise ArgumentError, "m must be between 0 and n" if m <= 0 || m > n
    raise ArgumentError, "l must be greater than 0" if l <= 0
  end
rescue Exception => e
  puts e.to_s
  exit
end

puts "result: %d" % Solver::solve(m, n, l)
