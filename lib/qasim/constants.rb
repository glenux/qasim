module Qasim
  APP_DATA_DIR = Pathname.new(File.dirname(__FILE__)).parent.parent.parent + "data"

	APP_ICON_PATH = File.join APP_DATA_DIR, "icons"

	APP_SYSCONFIG_DIR = "/etc/qasim/maps.d"

	APP_CONFIG_DIR = if ENV['XDG_CONFIG_HOME'] then
						 File.join ENV['XDG_CONFIG_HOME'], 'qasim'
					 else
						 File.join ENV['HOME'], '.config', 'qasim'
					 end
end
