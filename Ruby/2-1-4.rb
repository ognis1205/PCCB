# -*- coding: utf-8 -*-
# PCCB 2-1-4

module Solver
  def perm
    block_given? or enum_for(:perm)

    cache = self.sort
    yield cache.dup
    return if self.size < 2

    while true
      j  = self.size - 2
      j -= 1 while j > 0 && cache[j] >= cache[j + 1]
      if cache[j] < cache[j + 1]
        l  = self.size - 1
        l -= 1 while cache[j] >= cache[l]
        cache[j], cache[l] = cache[l], cache[j]
        cache[j+1..-1] = cache[j+1..-1].reverse
        yield cache.dup
      else
        break
      end
    end
  end
end
class Array; include Solver; end;

array = []

ARGV.each_with_index do |arg, index|
  begin
    array << Integer(arg)
  rescue Exception => e
    puts e.to_s
    exit
  end
end

array.perm {|p| puts p.join}