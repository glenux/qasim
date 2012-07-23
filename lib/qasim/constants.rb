module Qasim
	APP_ICON_PATH = File.join QASIM_DATA_DIR, "icons"
	APP_NAME = "Qasim"
	APP_VERSION = "0.1"

	APP_SYSCONFIG_DIR = "/etc/qasim/maps.d"

	APP_CONFIG_DIR = if ENV['XDG_CONFIG_HOME'] then
						 File.join ENV['XDG_CONFIG_HOME'], 'qasim'
					 else
						 File.join ENV['HOME'], '.config', 'qasim'
					 end
end
