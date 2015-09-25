# -*- coding: utf-8 -*-
# PCCB 1-6-1

class Problem
  def initialize(a)
    if a.kind_of?(Array) && a.all? {|x| x.is_a? Integer} then @a = a else @a = [] end
    @a.sort! {|x, y| y <=> x}
  end

  def solve
    for i in 0...@a.size
      for j in (i+1)...@a.size
        for k in (j+1)...@a.size
          if @a[i] < @a[j] + @a[k]
            print "answer: #{@a[i] + @a[j] + @a[k]} \n"
            return
          end
        end
      end
    end
    print "no answer found\n"
  end

  def debug
    print @a
    print "\n"
  end
end

$a = []
ARGV.each do |arg|
  $a << arg.to_i
end

problem = Problem.new($a)
problem.solve