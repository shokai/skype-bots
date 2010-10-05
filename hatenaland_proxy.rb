#!/usr/bin/env ruby
require 'rubygems'
require 'mechanize'
require 'nokogiri'
require 'kconv'
require 'json'
require 'socket'
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
  s.puts "MESSAGE #{conf['me']} hatenaland_proxy start"
rescue => e
  STDERR.puts e
  exit 1
end


@agent = Mechanize.new
#@agent.user_agent_alias = 'skype_hatenaland_proxy'
page = @agent.get('https://www.hatena.ne.jp/login?auto=0&backurl=http%3A%2F%2Fl.hatena.ne.jp%2F')
login_form = page.forms.first
login_form.fields_with(:name => 'name').first.value = conf['hatena_user']
login_form.fields_with(:name => 'password').first.value = conf['hatena_pass']
login_form.click_button


msgs = Array.new

EventMachine::run do
  
  EventMachine::defer do
    loop do
      res = s.gets
      exit unless res
      res = JSON.parse(res) rescue next
      p res
      if res['from'] == conf['me'] and res['type'] == 'chat_message'
        msgs << res['body'].toutf8
        puts "queue <- #{res['body']}"
      end
    end
  end

  EventMachine::defer do
    loop do
      next if msgs.size < 1
      msg = msgs.shift
      begin
        page = @agent.get('http://l.hatena.ne.jp/')
        post_form = page.forms.first
        post_form.fields_with(:name => 'body_text').first.value = msg
        post_form.click_button
        puts "post -> #{msg}"
      rescue => e
        STDERR.puts e
        s.puts "MESSAGE #{conf['me']} skype_hatenaland_proxy error #{e}"
        exit 1
      end
      sleep 10
    end
  end
  
end
