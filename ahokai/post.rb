#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require File.dirname(__FILE__)+'/helper'
require 'socket'

begin
  s = TCPSocket.open(@conf['host'], @conf['port'])
  s.puts "MESSAGE #{@conf['me']} ahokai start"
rescue => e
  STDERR.puts e
  exit 1
end

p start = @db['ngram'].find({:head => true}).map{|m|m}.choice

res = [start['a'], start['b'], start['c']]

# 左に伸ばす

# 右に伸ばす
w = start
loop do
  p w = @db['ngram'].find({:a => w['b'], :b => w['c'] }).map{|m|m}.choice
  break unless w
  res.push w['c']
  break if w['tail'] == true
end

puts mes = res.join('')

s.puts "CHATMESSAGE #{@conf['chat']} #{mes}"
s.close
