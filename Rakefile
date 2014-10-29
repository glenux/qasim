
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


desc "Do everything"
task :all => [:build, :install]

desc "Clean everything"
task :clean => [
	:clean_ui, 
	:clean_qrc, 
	:clean_bin,
	:clean_lib, 
	:clean_data,
	:"gem:clean"
]

desc "Build everything"
task :build => [
	:build_ui, 
	:build_qrc, 
	:build_bin,
	:build_lib, 
	:build_data,
	:"gem:build"
]

desc "Install everything"
task :install => [
	:install_ui, 
	:install_qrc, 
	:install_bin, 
	:install_lib, 
	:install_data
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

task :clean_qrc do
	rm_fr RBQRC_FILES
end

task :build_qrc => RBQRC_FILES do
	puts RBQRC_FILES
end

rule "_qrc.rb" => ".qrc" do |t|
	sh %Q{rbrcc #{t.source} -o #{t.name}}
end

namespace :gem do
	require "bundler/gem_tasks"

	desc "Clean stalling gem files from the pkg directory"
	task :clean do
		rm_rf Dir.glob('pkg/*.gem')
	end
end

require 'rake'
require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new do |t|
        #t.warning = true
        #t.verbose = true
        t.libs << "spec"
        t.test_files = FileList['spec/**/*_spec.rb']
end

