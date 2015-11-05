
require 'fileutils'
require 'qasim/map/generic'

module Qasim ; module Map ; class Ssh < Qasim::Map::Generic
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
    return [ :ssh, :sshfs ]
  end

	#
	# Set defaults properties for maps
	#
	def initialize *opts
		super
	end


  def mount_id
    return "fuse.sshfs"
  end

	#
	# Connect single map
	#
  # FIXME: test connexion with Net::SSH + timeout or ask password
  def mount_link name, remotepath
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
      "-o","cache_link_timeout=1800", # 30 min cache for links
      "-o","attr_timeout=1800", # 30 min attr cache
      "-o","entry_timeout=1800", # 30 min entry cache
      "-o","ServerAliveInterval=15", # prevent I/O hang
      "-o","ServerAliveCountMax=3", # prevent I/O hang
      "-o","no_readahead",
      #"-o","Ciphers=arcfour", # force cypher
      "-o","Port=%s" % @params[:ssh_port],
      "%s@%s:%s" % [@params[:ssh_user],@params[:ssh_host],remotepath],
      localpath ]
    STDERR.puts cmd + ' ' + cmd_args.join(' ')
  end
  




end ; end ; end

