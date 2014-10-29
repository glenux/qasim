require "bundler/gem_tasks"

NAME="qasim"
DESTDIR=""
DEV_DESTDIR="tmp"
CONFDIR="#{DESTDIR}/etc"
BINDIR="#{DESTDIR}/usr/bin"
MANDIR="#{DESTDIR}/usr/share/man"
DOCDIR="#{DESTDIR}/usr/share/doc"
SHAREDIR="#{DESTDIR}/usr/share"

RUBYVERSION="2.0"
RDOC="rdoc#{RUBYVERSION}"

QRC_FILES=$(wildcard lib/$(NAME)/*.qrc)
RBQRC_FILES=$(patsubst %.qrc,%_qrc.rb,$(QRC_FILES))
UI_FILES=$(wildcard lib/$(NAME)/ui/*.ui)
RBUI_FILES=$(patsubst %.ui,%_ui.rb,$(UI_FILES))

task :all => [:build, :install]

task :clean => [
	:clean_ui, 
	:clean_qrc, 
	:clean_bin,
	:clean_lib, 
	:clean_data
]

task :build => [
	:build_ui, 
	:build_qrc, 
	:build_bin,
	:build_lib, 
	:build_data
]

task :doc => [:build_doc]

task :install => [
	:install_ui, 
	:install_qrc, 
	:install_bin, 
	:install_lib, 
	:install_data
]

task :clean_doc do
	rm_rf doc
end

task :build_doc => :clean_doc do
	sh %q{$(RDOC)
		--promiscuous 
		--inline-source 
		--line-numbers 
		-o doc lib/$(NAME)/
		bin/
	}
end

task :clean_qrc do
	rm_fr $(RBQRC_FILES)
end

task :build_qrc => $(RBQRC_FILES) do
	echo $(RBQRC_FILES)
end

task %_qrc.rb: %.qrc do
	rbrcc $< -o $@
end

