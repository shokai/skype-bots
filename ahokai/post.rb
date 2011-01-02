#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require File.dirname(__FILE__)+'/helper'
require 'socket'
$KCODE = 'u'

p start = @db['ngram'].find({:head => true}).map{|m|m}.choice

res = [start['a'], start['b'], start['c']]

# 右に伸ばす
w = start
loop do
  p w = @db['ngram'].find({:a => w['b'], :b => w['c'] }).map{|m|m}.choice
  break unless w
  res.push w['c']
  break if w['tail'] == true and rand > 0.3
end

p mess = res.join('').split(/\n/)


begin
  s = TCPSocket.open(@conf['host'], @conf['port'])
rescue => e
  STDERR.puts e
  exit 1
end

for m in mess do
  s.puts "CHATMESSAGE #{@conf['chat']} m"
  sleep rand * 30
end
