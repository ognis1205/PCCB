# -*- coding: utf-8 -*-
# PCCB 1-6-3

class Solver
	def self.solve(s, a)
    prepare!(a)
    for i in 0...a.size
      for j in (i+1)...a.size
        for k in (j+1)...a.size
          l = binary_search(a, k, a.size - 1, s - a[i] - a[j] - a[k])
          if l > -1
            puts "answer: #{i} #{j} #{k} #{l}"
            return
          end
        end
      end
    end
	end

  def self.prepare!(a)
    a = a.kind_of?(Array) && a.all? {|x| x.is_a?(Integer)} ? a : []
    a.sort! {|x, y| x <=> y}
  end

  def self.binary_search(a, l, r, t)
    if l == r
      return a[l] == t ? l : -1
    end
    m = (l + r) / 2
    if a[m] < t
      return binary_search(a, m + 1, r, t)
    else
      return binary_search(a, l, m, t)
    end
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
	end
end

Solver.solve($sum, $array)