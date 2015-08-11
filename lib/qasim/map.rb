
require 'fileutils'

#require 'rdebug/base'
#require 'qasim/map/generic'

module Qasim ; module Map

	class ParseError < RuntimeError ; end
	class ConnectError < RuntimeError ;	end

  module_function :from_file

  def from_file

  end

  def to_file
  end


  #
  # replace magic values withing map lines
  #
  # Allowed values :
  #
  # $(var) => variable value from environment
  # ${var} => variable value from environment
  # 
  def env_substitute str, lineno
		local_env = ENV.clone
		while str =~ /\$(\w+)/ do
			case str
			when /\$\{(.+)\}/ then
				pattern = $1
				str.gsub!(/\$\{#{pattern}\}/,local_env[pattern])
			when /\$(\w+)/ then
				pattern = $1
				str.gsub!(/\$#{pattern}/,local_env[pattern])
			else 
				puts "w: unknown pattern: %s at str %d"  % [str, lineno]
			end
		end
    str
  end

	#
	# Load map description from file
	#
	def from_file filename
		f = File.open filename
		linect = 0
		f.each do |line|
			line = line.strip
			linect += 1

      line = env_substitute(line, linect)

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
				raise MapParseError, "parse error at #{@filename}:#{linect}"
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
end ; end
