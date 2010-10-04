#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
# キーワードに反応する単純なbot

require 'rubygems'
require 'socket'
require 'json'
require 'eventmachine'
$KCODE = 'u'

HOST = "192.168.1.37"
PORT = 20000

begin
  s = TCPSocket.open(HOST, PORT)
  s.puts "MESSAGE shokaishokai shokai_bot start"
rescue => e
  STDERR.puts e
  exit 1
end

EventMachine::run do
  loop do
    res = s.gets
    exit unless res
    res = JSON.parse(res) rescue next
    p res
    if res['type'] == 'chat_message' 
      if res['body'] =~ /(たや|taya)/ # キーワードに反応
        s.puts "CHATMESSAGE #{res['chat']} たや#{'ァ'rand(2)}！"
      elsif res['body'] =~ /(bot|ボット|ぼっと)/
        mes = ['ボットチガウ ボットチガウ', 'botじゃないですよ', 'botじゃないよ', 'botじゃないんですよ', 'http://github.com/shokai/skype-socket-gateway これ使ってる'].choice
        s.puts "CHATMESSAGE #{res['chat']} #{mes}"
      elsif res['body'] =~ /ぽわわ/
        s.puts "CHATMESSAGE #{res['chat']} ぽわわ〜"
      elsif res['body'] =~ /(ますい|masui|増井)/i
        s.puts "CHATMESSAGE #{res['chat']} ドヤッ！"
      elsif res['body'] =~ /(p.*e.*r.*o|ぺ.*ろ.*ぺ.*ろ|ペ.*ロ.*ペ.*ロ)/i
        s.puts "CHATMESSAGE #{res['chat']} ペロペロしないでください 不快です 死にます"
      elsif res['body'] =~ /(サイバ|event *machine)/i
        s.puts "CHATMESSAGE #{res['chat']} サイバーパンク！"
      elsif res['body'] =~ /(な.*る.*ほ|ナ.*ル.*ホ|わかった|わかり|そうか|納得)/
        mes = ['ナルホディウス！', 'ナルホディウス..', 'ふむふむ、ナルホディウスですぞ〜'].choice
        s.puts "CHATMESSAGE #{res['chat']} #{mes}"
      elsif res['body'] =~ /(五月蝿|うるさい|うぜえ|うざい|ウザイ|黙れ|自重|ひどい|酷|非道)/
        mes = ['自重します・・', 'うざくないよ！', 'ニャーン', 'ぽわわ', 'ごめん', 'もう寝よう！', '大丈夫だ、問題ない'].choice
        s.puts "CHATMESSAGE #{res['chat']} #{mes}"
      elsif res['body'] =~ /(できな|出来な|わから|無理|error|エラー|なんだと|動かな)/i
        mes = ['ぐぐれ', 'ググレカス', 'どうぞ http://google.com'].choice
        s.puts "CHATMESSAGE #{res['chat']} #{mes}"
      elsif res['body'] =~ /(すごい|すげ|凄|ゴイスー)/
        mes = ['どうも', 'ど〜も', '凄くないよ！', 'すごいだろ'].choice
        s.puts "CHATMESSAGE #{res['chat']} #{mes}"
      elsif res['body'] =~ /(https?\:[\w\.\~\-\/\?\&\+\=\:\@\%\;\#\%]+)/i
        url = res['body'].scan(/(https?\:[\w\.\~\-\/\?\&\+\=\:\@\%\;\#\%]+)/i).first
        mes = ['まて・・罠かもしれない', 'それはブラクラですよ！', 'ブラクラ貼らないでください！',
               "これフィッシングサイトだよね #{url}", "そのサイト1年以上前から知ってたわー"].choice
        s.puts "CHATMESSAGE #{res['chat']} #{mes}"
      elsif res['body'] =~ /[wｗ]/i
        s.puts "CHATMESSAGE #{res['chat']} #{'w'*(rand(2)+1)}"
      elsif res['from'] != 'shokaishokai'
        next if rand > 0.2
        mes = ['へえ', 'なるほど', 'そっかー', "つまり、#{res['body']}ってことでしょ", 'んで？', 'はい', 'で？', 'うん',
               "メモメモ。。「#{res['body']}」", 'ですよねー', 'ですよね。。', '＼(^o^)／'].choice
        s.puts "CHATMESSAGE #{res['chat']} #{mes}"
      end
    end
    sleep 0.1
  end
end

