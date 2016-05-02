require "fluent/config"
require "redis"

module Fluent
	module Mixin
		module KvsConfig
			DEFAULT_DRIVER = "redis"
			DEFAULT_PREFIX = "KVSCONF_"

			def configure(conf)
				driver = if conf.keys.include?("kvs_driver")
							conf["kvs_driver"]
						 else
							DEFAULT_DRIVER
						 end

				case driver
				when "redis"
					@driver = DriverRedis.new(conf)
#				when "memcached"
#					@driver = DriverMemcached.new(conf)
				end
				@prefix =	if conf.keys.include?("kvs_prefix") && conf["kvs_prefix"]
								conf["kvs_prefix"]
							else
								DEFAULT_PREFIX
							end

				@driver.connect()

				mapping = {}
				@driver.allkeys(@prefix).each do |key| 
					mapping["$KVS{" + key + "}"] = @driver.get(key)
				end
				check_element(mapping, conf)
			end

			def replace(map, value)
				map.reduce(value) {|r, p| r.gsub(p[0], p[1]) }
			end

			def check_element(map, conf)
				conf.arg = replace(map, conf.arg)
				conf.keys.each do |k|
					v = conf.fetch(k, nil)
					if v and v.is_a? String
						conf[k] = replace(map, v)
					end
				end
				conf.elements.each{|e| check_element(map, e) }
			end

			class DriverBase
				def initialize(conf)
					@host =	conf["kvs_host"]
					@port = conf["kvs_port"]
					@engine = nil
				end

				def connect()
					raise NotImplementedError, "DON'T use this Fluent::Mixin::KvsConfig::DriverBase directly."
				end

				def allkeys(prefix)
					raise NotImplementedError, "DON'T use this Fluent::Mixin::KvsConfig::DriverBase directly."
				end

				def get(key)
					raise NotImplementedError, "DON'T use this Fluent::Mixin::KvsConfig::DriverBase directly."
				end
			end

			class DriverRedis < DriverBase
				def initialize(conf)
					super

					if !@port
						@port = 6379
					end

					@db =	if conf["kvs_db"]
								conf["kvs_db"]
							else
								0
							end
				end
				def connect()
					@engine = Redis.new(:host => @host,
										:port => @port,
										:db => @db)
				end

				def allkeys(prefix)
					pattern = String.new(prefix)
					@engine.keys(pattern.concat('*'))
				end

				def get(key)
					@engine.get(key)
				end
			end
		end
	end
end
