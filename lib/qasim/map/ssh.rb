
require 'fileutils'
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
	CYPHER_AES256CBC = :"aes-256-cbc"
	CYPHERS = [ 
    CYPHER_ARCFOUR, 
    CYPHER_AES256CBC
  ]

  def self.parameters
    super.merge({
      ssh_user:     { required: true },           # ex : foo
      ssh_password: { required: true },           # ex : bar
      ssh_host:     { required: true },           # ex : localhost, 127.0.0.1, ...
      ssh_port:     { default: 80 },              # ex : 80, 8080, ...
      ssh_cypher:   { default: CYPHER_AES256CBC } # ex : http, https
    })
  end

  def self.handles
    [ :ssh, :sshfs ]
  end

	#
	# Set defaults properties for maps
	#
	def initialize *opts
		super
	end

  def mount_include? fs_type, local_path
		f = File.open("/proc/mounts")
		fs_mounts = (f.readlines.select do |line|
			line =~ /\s+#{fs_type}\s+/
		end).map do |line| 
			line.split(/\s+/)[1]
		end
		f.close
    fs_mounts.include? local_path
  end

	#
	# Test if map is connected / mounted
	#
	def mounted? 
		score = @links.size
		@links.each do |name, remotepath|
			local_path = File.join @app_config.mount_dir, name

			if mount_include?("fuse.sshfs", local_path) then
				score -= 1
			end
		end
		# FIXME: handle the case of partial mounts (for remount/umount)
		return true if score == 0
    return false
	end


	#
	# Connect map
	#
	def mount &block
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
	def umount &block
		@links.each do |name, remotepath|
			localpath = File.join ENV['HOME'], "mnt", name
			cmd = "fusermount"
			cmd_args = [
				"-u", #umount
				"-z" ,#lazy
				localpath ]
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

