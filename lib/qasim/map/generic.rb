
require 'fileutils'
require 'pp'

module Qasim ; module Map; class Generic
  attr_reader :links
  attr_reader :filename
  attr_reader :name

  def initialize app_config, params
    @app_config = app_config    
    @links = params[:links]
		params.delete :links

		@filename = params[:filename] 
		params.delete :filename
		@name = File.basename @filename, '.map'
		@params = params
		pp @params
  end


  # Return a list of options for this map type
  #
  # Format :
  # Hash of (name:Symbol * [value:Object, optional:Boolean])
  def self.parameters
    return {
      map_name:       [nil , true],
      map_enable:     [true, false],
      map_mountpoint: [nil, true]
    }
  end

  #
  # Test if mount  list include some path & fs type
  # 
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

			if mount_include?(self.mount_id, local_path) then
				score -= 1
			end
		end
    
		# FIXME: handle the case of partial mounts (for remount/umount)
		return true if score == 0
    return false
	end

  #
	# Connect all maps
	#
	def mount &block
		@links.each do |name, remotepath|
			mount_link(name, remotepath)
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
	# Disconnect all maps
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
  
  
  #
  # Connect a single map
  #
  # MUST BE IMPLEMENTED BY SUBCLASSES
  #
  def mount_link name, remotepath
    raise NotImplementedError
  end
  
  
  #
  # Return the name of fuse helper (show in mount  list)
  #
  # MUST BE IMPLEMENTED BY SUBCLASSES
  #
  def mount_id
    raise NotImplementedError
  end
  
  #
  # Test map liveness (connected & working)
  #
  # MUST BE IMPLEMENTED BY SUBCLASSES
  #
  def alive?
    raise NotImplementedError
  end
end ; end ; end
