
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

QRC_FILES=Dir.glob("lib/#{NAME}/*.qrc")
RBQRC_FILES=QRC_FILES.map{ |f| f.sub(/\.qrc$/,'_qrc.rb') }

UI_FILES=Dir.glob("lib/#{NAME}/ui/*.ui")
RBUI_FILES=UI_FILES.map{ |f| f.sub(/\.ui$/,'_ui.rb') }

require 'rake'
#Rake.application.options.trace_rules = true


desc "Do everything"
task :all => [:build, :install]

desc "Clean everything"
task :clean => [
	:"ui:clean", 
	:"qrc:clean", 
	#:clean_bin,
	#:clean_lib, 
	#:clean_data,
	:"gem:clean"
]

desc "Build everything"
task :build => [
	:"ui:build",
	:"qrc:build",
	#:build_bin,
	#:build_lib, 
	#:build_data,
	:"gem:build"
]

desc "Install everything"
task :install => [
	#:"ui:install", 
	#:"qrc:install",
	#:install_bin, 
	#:install_lib, 
	#:install_data
]

desc "Build documentation"
task :doc => [:build_doc]

task :clean_doc do
	rm_rf doc
end

task :build_doc => :clean_doc do
	sh %Q{#{RDOC}
		--promiscuous 
		--inline-source 
		--line-numbers 
		-o doc lib/$(NAME)/
		bin/
	}
end

namespace :qrc do
	desc "Clean QRC files"
	task :clean do
		rm_rf RBQRC_FILES
	end

	desc "Build QRC files"
	task :build => RBQRC_FILES do
		puts RBQRC_FILES
	end

	rule "_qrc.rb" => lambda{|f| f.gsub(/_qrc\.rb/,'.qrc') } do |t|
		sh %Q{rbrcc #{t.source} -o #{t.name}}
	end
end

namespace :ui do
	desc "Clean UI files"
	task :clean do
		rm_rf RBUI_FILES
	end

	desc "Build UI files"
	task :build => RBUI_FILES do
		puts RBQRC_FILES
	end

	rule "_ui.rb" => lambda{|f| f.gsub(/_ui\.rb/,'.ui') } do |t|
		sh %Q{rbuic4 #{t.source} -o #{t.name}}
		sh %Q{sed -e '/^module Ui/,/^end  # module Ui/d' -i #{t.name}}
	end
end


namespace :gem do
	require "bundler/gem_tasks"

	desc "Clean stalling gem files from the pkg directory"
	task :clean do
		rm_rf Dir.glob('pkg/*.gem')
	end
end

require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new do |t|
    #t.warning = true
    #t.verbose = true
    t.libs << "spec"
    t.test_files = FileList['spec/**/*_spec.rb']
end

