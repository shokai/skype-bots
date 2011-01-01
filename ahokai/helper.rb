#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'rubygems'
require 'yaml'
require 'mongo'
$KCODE = 'u'

begin
  @conf = YAML::load open(File.dirname(__FILE__)+'/config.yaml')
rescue => e
  STDERR.puts "config.yaml laod error"
  STDERR.puts e
  exit 1
end

begin
  @m = Mongo::Connection.new(@conf['mongo_host'], @conf['mongo_port'])
  @db = @m.db(@conf['mongo_dbname'])
rescue => e
  STDERR.puts "mongo db connection error"
  STDERR.puts e
  exit 1
end
