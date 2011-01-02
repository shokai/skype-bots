#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require File.dirname(__FILE__)+'/helper'
require 'igo-ruby'
$KCODE = 'u'

tagger = Igo::Tagger.new('/usr/local/share/ipadic')

start_at = Time.now

for user in @conf['source_users'] do
  chats = @db['chat'].find({:from => user})

  # 同一人物で60秒以内のpostは連結する
  joined = Array.new
  last_time = 0
  chats.each{|c|
    if c['time']-last_time < 60
      joined[joined.size-1] += "\n#{c['body']}"
    else
      joined << c['body']
    end
    last_time = c['time']
  }
  
  chats = joined
  
  count = 0
  chats.each{|c|
    words = c.split(/([\n 　\t])/).map{|i|
      if i =~ /[\n 　\t]/
        res = i
      else
        res = tagger.wakati i
      end
      res
    }.flatten
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
end

puts "---finished!!"
puts "#{Time.now.to_i - start_at.to_i} (sec)"
puts "stored #{chats.count} chats / #{count} 3grams"

