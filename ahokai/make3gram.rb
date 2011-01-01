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
    @db['ngram'].save({
                        :a => words[i], :b => words[i+1], :c => words[i+2]
                      })
  end
  p words
}

puts "---finished!!"
puts "#{Time.now.to_i-start.to_i} (sec)"
puts "stored #{chats.count} chats / #{count} 3grams"
