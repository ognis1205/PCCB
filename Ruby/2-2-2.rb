# -*- coding: utf-8 -*-
# PCCB 2-2-2

module Solver
  def self.solve(tasks)
    result   = 0
    end_time = 0
    tasks    = tasks.sort {|l, r| l[:end_time] <=> r[:end_time]}
    tasks    = tasks.find_all {|task| task[:start_time] > end_time}

    while tasks.size > 0
      result   += 1
      end_time  = tasks.shift[:end_time]
      tasks     = tasks.find_all {|task| task[:start_time] > end_time}
    end

    return result
  end
end

tasks = []

class << tasks
  def show
    cache = self.sort {|l, r| l[:start_time] <=> r[:end_time]}
    cache.each do |task|
      puts "start at: %4d, end at: %4d" % [task[:start_time], task[:end_time]]
    end
  end
end

ARGV.each_with_index do |arg, index|
  begin
    s, e = arg.split(/,/)
    s = Integer(s); e = Integer(e);
    if s != nil && s >= 0 && e != nil && e >= s
      tasks << {start_time: s, end_time: e}
    end
  rescue Exception => e
    puts e.to_s
    exit
  end
end

puts "result: %4d" % [Solver.solve(tasks)]