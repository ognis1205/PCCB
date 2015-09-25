# -*- coding: utf-8 -*-
# PCCB 1-6-2

class Problem
	def self.solve(length, ants)
		max = nil
		min = nil
		for ant in ants do
			candidate = MAX(length - ant, ant)
			max = max != nil && max > candidate ? max : candidate
			min = min != nil && min < candidate ? min : candidate
		end
		print "max: #{max}\n"
		print "min: #{min}\n"
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
		print e.to_s
	end
end

Problem.solve($length, $ants)