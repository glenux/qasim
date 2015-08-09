
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
RBQRC_TO_QRC = lambda{|f| f.gsub(/_qrc\.rb/,'.qrc') }

UI_FILES=Dir.glob("lib/#{NAME}/ui/*.ui")
RBUI_FILES=UI_FILES.map{ |f| f.sub(/\.ui$/,'_ui.rb') }

require 'rake'
require 'rake/testtask'

#Rake.application.options.trace_rules = true

Rake::TaskManager.record_task_metadata = true


desc "Clean everything"
task :clean => [
	:"ui:clean", 
	:"qrc:clean", 
	:"gem:clean"
]

desc "Build everything"
task :build => [
	:"ui:build",
	:"qrc:build",
	:"doc:build",
	:"gem:build"
]


namespace :doc do
  task :clean do
	  rm_rf "doc"
  end

  task :build => :clean do
	  sh [RDOC, 
       "--promiscuous",
       "--inline-source", 
       "--line-numbers",
       "-o", "doc",
       "lib/#{NAME}/", "bin/"
    ].join(" ")
  end
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

	rule "_qrc.rb" => RBQRC_TO_QRC do |t|
		sh %Q{rbrcc #{t.source} -o #{t.name}}
	end
end


desc "UI related tasks"
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


Rake::TestTask.new do |t|
  #t.warning = true
  #t.verbose = true
  t.libs << "spec"
  t.test_files = FileList['spec/**/*_spec.rb']
end

# Set default task to list all task
desc "Default task (build)"
task :default do
  puts "Usage : rake <taskname>"
  puts ""

  Rake::application.options.show_tasks = :tasks  # this solves sidewaysmilk problem
  Rake::application.options.show_task_pattern = //
  Rake::application.display_tasks_and_comments
end
