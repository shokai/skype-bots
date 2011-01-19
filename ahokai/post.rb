#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require File.dirname(__FILE__)+'/helper'
require 'eventmachine'
require 'socket'
require 'json'
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

puts mess = res.join('').split(/\n/)


begin
  s = TCPSocket.open(@conf['host'], @conf['port'])
rescue => e
  STDERR.puts e
  exit 1
end

EventMachine::run do
  EventMachine::defer do
    for i in 0...mess.size do
      m = mess[i]
      puts query = "CHATMESSAGE #{@conf['chat']} #{m}"
      s.puts query
      sleep rand*30 + 5 if i < mess.size-1
    end
    sleep 10
    exit 0
  end

  EventMachine::defer do
    loop do
      res = s.gets
      exit unless res
      res = JSON.parse res rescue next
      p res
    end
  end
end

