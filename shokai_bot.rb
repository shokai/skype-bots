#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
# キーワードに反応する単純なbot

require 'rubygems'
require 'socket'
require 'json'
require 'yaml'
require 'eventmachine'
$KCODE = 'u'

begin
  conf = YAML::load open(File.dirname(__FILE__)+'/config.yaml')
rescue => e
  STDERR.puts "config.yaml laod error"
  STDERR.puts e
  exit 1
end


begin
  s = TCPSocket.open(conf['host'], conf['port'])
  s.puts "MESSAGE #{conf['me']} shokai_bot start"
rescue => e
  STDERR.puts e
  exit 1
end

EventMachine::run do
  
  EventMachine::defer do
    loop do
      res = s.gets
      exit unless res
      res = JSON.parse(res) rescue next
      p res
      if res['type'] == 'chat_message'
        next if rand > 0.4
        if res['body'] =~ /(たや|taya|田屋|田矢|たーや|[んン]ッ?ー|おー)/ # キーワードに反応
          mes = ["たや#{'ァ'*rand(3)}！",
                 ['ん','ン','んっ','ンッ','をっ','オッ'].choice+'ー'*rand(7)+'！'*rand(5)].choice
          s.puts "CHATMESSAGE #{res['chat']} #{mes}"
        elsif res['body'] =~ /(辛|つら)い/
          mes = '元気出せよ、な？ おまえならきっと大丈夫だよ。'
          s.puts "CHATMESSAGE #{res['chat']} #{mes}"
        elsif res['body'] =~ /(bot|ボット|ぼっと)/
          gapi = ''
          rand(15).times do 
            gapi+='ガーピー'.split(//u).choice
          end
          mes = ['にゃ〜ん','ニャーン','ボットチガウ ボットチガウ', 'いかにも！' ,'botじゃないですよ', 'botじゃないよ', 'botじゃないんですよ', 'http://github.com/shokai/skype-socket-gateway これ使ってる', gapi].choice
          s.puts "CHATMESSAGE #{res['chat']} #{mes}"
        elsif res['body'] =~ /ぽわわ/
          s.puts "CHATMESSAGE #{res['chat']} ぽわわ〜"
        elsif res['body'] =~ /(ますい|masui|増井)/i
          mes = ['絶対に許せない！','ドヤッ！', 'ドヤァ〜', 'ドヤ！？', 'ドヤァ・・・'].choice
          s.puts "CHATMESSAGE #{res['chat']} #{mes}"
        elsif res['body'] =~ /(pero|ぺろぺろ|ペロペロ|ﾍﾟﾛﾍﾟﾛ)/i
          mes = ['ペロペロしないでください 不快です 死にます', 'もうペロペロはしないって言ったじゃないですかァーッ'].choice
          s.puts "CHATMESSAGE #{res['chat']} #{mes}"
        elsif res['body'] =~ /(サイバ|event *machine)/i
          mes = ['サイバーパンク！', 'インターネット！'].choice
          s.puts "CHATMESSAGE #{res['chat']} #{mes}"
        elsif res['body'] =~ /(な.*る.*ほ|ナ.*ル.*ホ|わかった|わかり|そうか|納得)/
          mes = ['ナルホディウス！', 'ナルホディウス..', 'ふむふむ、ナルホディウスですぞ〜'].choice
          s.puts "CHATMESSAGE #{res['chat']} #{mes}"
        elsif res['body'] =~ /(五月蝿|うるさい|うぜえ|うざい|ウザイ|黙れ|自重|ひどい|酷|非道)/
          mes = ['自重します・・', 'うざくないよ！', 'ニャーン', 'ギャーン', 'ぽわわ', 'ごめん', 'もう寝よう！', '大丈夫だ、問題ない'].choice
          s.puts "CHATMESSAGE #{res['chat']} #{mes}"
        elsif res['body'] =~ /(できな|出来な|わから|無理|error|エラー|なんだと|動かな|何ですか|なんですか|教えて|って何|のかな)/i
          mes = ['ぐぐれ', 'ググレカス', 'え〜', 'どうぞ http://google.com', '乙', '凸'].choice
          s.puts "CHATMESSAGE #{res['chat']} #{mes}"
        elsif res['body'] =~ /(すごい|すげ|凄|ゴイスー)/
          mes = ['どうも', 'ど〜も', '凄くないよ！', 'うん', 'すごいだろ', 'はい'].choice
          s.puts "CHATMESSAGE #{res['chat']} #{mes}"
        elsif res['body'] =~ /(https?\:[\w\.\~\-\/\?\&\+\=\:\@\%\;\#\%]+)/i
          url = res['body'].scan(/(https?\:[\w\.\~\-\/\?\&\+\=\:\@\%\;\#\%]+)/i).first
          mes = ['やめなさい', 'や〜め〜ろ〜よ〜', 'は'*rand(8), 'ハ'*rand(10), "そのサイト1年以上前から知ってたわー"].choice
          s.puts "CHATMESSAGE #{res['chat']} #{mes}"
        elsif res['body'] =~ /[wｗ]/i
          s.puts "CHATMESSAGE #{res['chat']} #{'w'*(rand(2)+1)}"
        elsif res['from'] != conf['me']
          next if rand > 0.2
          mes = ['へえ', 'なるほど', 'そっかー', "つまり、#{res['body']}ってことでしょ", 'んで？', 'はい', 'で？', 'うん', 'うへぇ',
                 "メモメモ。。「#{res['body']}」", 'ですよねー', 'ですよね。。', '＼(^o^)／', 'えらい！', 'まったく、大した奴だ・・',
                 "#{res['body']}ニョリ", 'ニョリ・・', '眠い', 'かずすけ空爆したい', 'もう寝よう！', 'ざんまい爆発しろ', '後ろだ','残像だ',
                'わ〜', 'え〜', 'ハー', 'しまった', 'ぐぬぬ・・・', 'え〜', '(^q^)', 'しまった！', '13kmや', '嘘だッ！', 'それも嘘だ',
                 'ミストルティンキーック！', "myatsumotoランキング#{rand(15)}位ですよ　おめでとう"].choice
          s.puts "CHATMESSAGE #{res['chat']} #{mes}"
        end
      end
    end
  end


  EventMachine::defer do
    s.puts gets
  end

end

