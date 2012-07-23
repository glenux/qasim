
require 'fileutils'
require 'rubygems'
#require 'rdebug/base'
require 'qasim/config'

module Qasim

	class Map 
		attr_reader :path,
		   	:host, 
			:port, 
			:enable, 
			:user, 
			:map,
			:name

		class MapParseError < RuntimeError ; end
		class ConnectError < RuntimeError ;	end

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
		# Load map description from file
		#
		def load path=nil
			@path=path unless path.nil?
			#rdebug "Parsing map #{@path}"
			f = File.open @path
			linect = 0
			local_env = ENV.clone
			f.each do |line|
				line = line.strip
				linect += 1

				while line =~ /\$(\w+)/ do
					#puts "FOUND PATTERN %s => %s" % [$1, local_env[$1]]
					case line
					when /\$\{(.+)\}/ then
						pattern = $1
						puts pattern
						line.gsub!(/\$\{#{pattern}\}/,local_env[pattern])
					when /\$(\w+)/ then
						pattern = $1
						line.gsub!(/\$#{pattern}/,local_env[pattern])
					else 
						puts "w: unknown pattern: %s"  % line
					end
				end

				case line
				when /^\s*REMOTE_USER\s*=\s*(.*)\s*$/ then
					@user = $1
					#rdebug "d: remote_user => #{$1}"
				when /^\s*REMOTE_PORT\s*=\s*(.*)\s*$/ then
					@port = $1.to_i
					#rdebug "d: remote_port => #{$1}"
				when /^\s*REMOTE_HOST\s*=\s*(.*)\s*$/ then
					@host = $1
					#rdebug "d: remote_host => #{$1}"
				when /^\s*REMOTE_CYPHER\s*=\s*(.*)\s*$/ then
					if CYPHERS.map{|x| x.to_s}.include? $1 then
						@host = $1.to_sym
					end
				when /^\s*MAP\s*=\s*(.*)\s+(.*)\s*$/ then
					@links[$1] = $2
					#rdebug "d: link #{$1} => #{$2}"
				when /^\s*$/,/^\s*#/ then
					#rdebug "d: dropping empty line"
				else
					raise MapParseError, "parse error at #{@path}:#{linect}"
				end
			end
			f.close
		end


		#
		# Write map description to file
		#
		def write path=nil
			@path=path unless path.nil?

			File.open(@path, "w") do |f|
				f.puts "REMOTE_USER=%s" % @user
				f.puts "REMOTE_PORT=%s" % @port
				f.puts "REMOTE_HOST=%s" % @host
				f.puts "REMOTE_CYPHER=%s" % @cypher
			end
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
					"-o","reconnect",
					"-o","workaround=all",
					"-o","cache_timeout=240",
					"-o","ServerAliveInterval=15",
					"-o","no_readahead",
					"-o","Ciphers=arcfour",
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
end
