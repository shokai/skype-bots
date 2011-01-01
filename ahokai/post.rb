#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require File.dirname(__FILE__)+'/helper'
require 'socket'
$KCODE = 'u'

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



puts query = "CHATMESSAGE #{@conf['chat']} #{mes}"

begin
  s = TCPSocket.open(@conf['host'], @conf['port'])
  s.puts query
rescue => e
  STDERR.puts e
  exit 1
end

