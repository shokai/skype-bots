require 'rubygems'
require 'yaml'
require 'mongo'
require 'bson'

@conf = YAML::load open(File.dirname(__FILE__)+'/../config.yaml')
@mongo = Mongo::Connection.new(@conf['mongo_host'], @conf['mongo_port'])
@db = @mongo[@conf['mongo_dbname']]
