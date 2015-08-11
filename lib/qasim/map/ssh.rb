
require 'fileutils'
require 'qasim/map'
require 'qasim/map/generic'

class Qasim::Map::Ssh < Qasim::Map::Generic
	attr_reader :path,
		:host, 
		:port, 
		:enable, 
		:user, 
		:map,
		:name

	CYPHER_ARCFOUR = :arcfour
	CYPHER_AES256CBC = "aes-256-cbc".to_sym
	CYPHERS = [ CYPHER_ARCFOUR, CYPHER_AES256CBC ]


	#
	# Set defaults properties for maps
	#
	def initialize config, map_path
		@config = config
		@path = map_path
		@host = nil
		@port = 22
		@enable = false
		@user = nil
		@cypher = :arcfour
		@links = {}
		@debug = false
		@name = (File.basename map_path).gsub(/\.map$/,'')

		self.load @path
	end




	#
	# Test map liveness (how ?)
	# FIXME: not implemented
	#
	def online?
		#rdebug  "testing online? %s " % self.inspect
		#FIXME: test liveness
	end


	#
	# Test if map is connected / mounted
	#
	def connected? 
		f = File.open("/proc/mounts")
		sshfs_mounted = (f.readlines.select do |line|
			line =~ /\s+fuse.sshfs\s+/
		end).map do |line| 
			line.split(/\s+/)[1]
		end
		f.close

		score = 0
		@links.each do |name, remotepath|
			score += 1
			local_path = File.join @config.mnt_dir, name

			if sshfs_mounted.include? local_path then
				score -= 1
			end
		end
		if score == 0 then return true
		else return false
			# FIXME: explain why ?
		end
	end


	#
	# Connect map
	#
	def connect &block
		puts "[#{File.basename @path}] Connecting..."
		puts "  #{@user}@#{@host}:#{@port}"
		#puts "  links = %s" % @links.map{ |k,v| "%s => %s" % [ k, v ] }.join(', ')
		# do something
		# test server connection
		# mount
		#
		# FIXME: test connexion with Net::SSH + timeout or ask password
		@links.each do |name, remotepath|
			localpath = File.join ENV['HOME'], "mnt", name
			FileUtils.mkdir_p localpath
			cmd = "sshfs"
			cmd_args = [
				"-o","allow_root" ,
				"-o","idmap=user" ,
				"-o","uid=%s" % Process.uid,
				"-o","gid=%s" % Process.gid,
				"-o","reconnect", # auto-reconnection
				"-o","workaround=all",
				"-o","cache_timeout=900", # 15 min cache for files
				"-o","cache_stat_timeout=1800", # 30 min cache for directories
				"-o","cache_link_timout=1800", # 30 min cache for links
				"-o","attr_timeout=1800", # 30 min attr cache
				"-o","entry_timeout=1800", # 30 min entry cache
				"-o","ServerAliveInterval=15", # prevent I/O hang
				"-o","ServerAliveCountMax=3", # prevent I/O hang
				"-o","no_readahead",
				#"-o","Ciphers=arcfour", # force cypher
				"-o","Port=%s" % @port,
				"%s@%s:%s" % [@user,@host,remotepath],
				localpath ]
			#rdebug "command: %s" % [ cmd, cmd_args ].flatten.join(' ')
			if block_given? then
				yield name, cmd, cmd_args
			else
				system cmd, cmd_args
				if $?.exitstatus != 0 then
					raise ConnectError, self
				end
			end
		end
	end


	#
	# Disconnect map
	#
	def disconnect &block
		puts "Disconnecting map #{@path}"
		@links.each do |name, remotepath|
			localpath = File.join ENV['HOME'], "mnt", name
			cmd = "fusermount"
			cmd_args = [
				"-u", #umount
				"-z" ,#lazy
				localpath ]
			#rdebug "command: %s" % [ cmd, cmd_args ].flatten.join(' ')
			if block_given? then
				yield name, cmd, cmd_args
			else
				system cmd, cmd_args
				if $?.exitstatus != 0 then
					raise ConnectError, self
				end
			end
		end
	end
end
