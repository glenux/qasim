
require 'fileutils'
require 'qasim/map/generic'
require 'qasim/map/ssh'
require 'qasim/map/webdav'

module Qasim ; module Map

	class ParseError < RuntimeError ; end
	class ConnectError < RuntimeError ;	end

  def class_for type
    plugin = nil
    ObjectSpace.each_object(Class) do |cls|
      if cls < Qasim::Map::Generic then
        plugin = cls if cls.handles.include? type.to_sym
      end 
    end
    plugin
  end

  #
  # replace magic values withing map lines
  #
  # Allowed values :
  #
  # $(var) => variable value from environment
  # ${var} => variable value from environment
  # 
  def env_substitute text
    seek = true
    str = text

		while seek do
      seek = false
			case str
			when /^(.*)\${([^}]+?)}(.*)$/ then
        before, pattern, after = [$1, $2, $3]
        pattern_value = env_substitute(pattern)
        pattern_value = (ENV[pattern_value] || "")
				str = before + pattern_value + after
        seek = true
			when /^(.*)\$(\w+)(.*)$/ then
        before, pattern, after = [$1, $2, $3]
        pattern_value = (ENV[pattern] || "")
				str = before + pattern_value + after
        seek = true
			end
		end
    str
  end

	#
	# Load description from file and create a Map object
	#
	def from_file appcfg, filename
    config = {
      type: :ssh  # for config V1, we assume SSHFS 
    }
    map = nil

		f = File.open filename
		linect = 0
		f.each do |line|
			line = line.strip
			linect += 1

      line = env_substitute(line, linect)

			case line
      when /^\s*TYPE\s*=\s*(.*)\s*$/ then
        config[:type] = $1
			when /^\s*REMOTE_USER\s*=\s*(.*)\s*$/ then
        config[:user] = $1
			when /^\s*REMOTE_PORT\s*=\s*(.*)\s*$/ then
        config[:port] = $1.to_i
			when /^\s*REMOTE_HOST\s*=\s*(.*)\s*$/ then
				config[:host] = $1
			when /^\s*REMOTE_CYPHER\s*=\s*(.*)\s*$/ then
				if CYPHERS.map(&:to_s).include? $1 then
					config[:cypher] = $1.to_sym
				end
			when /^\s*MAP\s*=\s*(.*)\s+(.*)\s*$/ then
        config[:links] ||= {}
        config[:links][$1] = $2
			when /^\s*$/,/^\s*#/ then
			else
				raise MapParseError, "parse error at #{@filename}:#{linect}"
			end
		end
		f.close
    map = Ssh.new config, filename
    return map
	end


	#
	# Write map description to file
	#
	def to_file path=nil
		@path=path unless path.nil?

		File.open(@path, "w") do |f|
			f.puts "REMOTE_USER=%s" % @user
			f.puts "REMOTE_PORT=%s" % @port
			f.puts "REMOTE_HOST=%s" % @host
			f.puts "REMOTE_CYPHER=%s" % @cypher
		end
	end
  module_function :from_file,
    :env_substitute,
    :class_for
end ; end

