
# vim: set ts=2 sw=2 et:
require 'fileutils'
require 'qasim/map/generic'

module Qasim; module Map; class Samba < Qasim::Map::Generic
  def initialize *opts
		super
  end

  def self.parameters
    super.merge({
      smb_user:     { required: true}, # ex :           foo
      smb_password: { required: true}, # ex :           bar
    })
  end

  def self.handles
    return [ :samba, :cifs, :smb ]
  end
  
	def mount_id
    return "fuse.fusesmb"
  end
  
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

