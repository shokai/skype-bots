#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require File.dirname(__FILE__)+'/helper'
require 'igo-ruby'

tagger = Igo::Tagger.new('/usr/local/share/ipadic')

chats = @db['chat'].find({:from => 'shokaishokai'})
start = Time.now

count = 0
chats.each{|c|
  words = tagger.wakati c['body']
  next if words.size < 3
  for i in 0...words.size-3 do
    count += 1
    n = {'a' => words[i], 'b' => words[i+1], 'c' => words[i+2]}
    tmp = @db['ngram'].find_one n
    if tmp
      n = tmp
      n['count'] += 1
    else
      n['count'] = 1
    end
    n['head'] = true if i == 0
    n['tail'] = true if i == words.size-4
    @db['ngram'].save n
  end
  p words
}

puts "---finished!!"
puts "#{Time.now.to_i-start.to_i} (sec)"
puts "stored #{chats.count} chats / #{count} 3grams"
