# -*- coding: utf-8 -*-
# PCCB 2-2-1

module Solver
  module Wallet
    def contain?(coin)
      return self.has_key?(coin)
    end

    def show
      cache = self.sort {|(k1, v1), (k2, v2)| k1.to_i <=> k2.to_i}
      cache.each do |coin, count|
        puts "coin: %3s => %3d" % [coin, count]
      end
    end
  end

  @context = {
    '1'   => 0,
    '5'   => 0,
    '10'  => 0,
    '50'  => 0,
    '100' => 0,
    '500' => 0
  }
  class << @context; include Wallet; end;

  def self.solve(residual, wallet)
    cache = wallet.sort {|(k1, v1), (k2, v2)| k2.to_i <=> k1.to_i}
    cache.each do |coin, count|
      amount  = 0
      amount += 1 while residual >= amount * coin.to_i && amount <= wallet[coin]
      amount -= 1
      @context[coin] = amount if @context.contain?(coin)
      residual -= amount * coin.to_i
    end

    if residual == 0
      puts "found: "
      @context.show
    else
      puts "still remaining: ¥%4d" % [residual]
    end
  end
end

target = 0

wallet = {
  '1'   => 0,
  '5'   => 0,
  '10'  => 0,
  '50'  => 0,
  '100' => 0,
  '500' => 0
}
class << wallet; include Solver::Wallet; end;

ARGV.each_with_index do |arg, index|
  begin
    if index == 0
      target = Integer(arg)
    else
      coin, count = arg.split(/=+/)
      if coin != nil && count != nil
        count = Integer(count)
        wallet[coin] = count if wallet.contain?(coin) && count >= 0
      end
    end
  rescue Exception => e
    puts e.to_s
  end
end

Solver.solve(target, wallet)