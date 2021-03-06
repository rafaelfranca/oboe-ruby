#!/usr/bin/env rake

require 'rubygems'
require 'bundler/setup'
require 'rake/testtask'
require 'appraisal'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end

task :default => :test

desc "Build the gem's c extension"
task :compile do
  puts "== Building the c extension against Ruby #{RUBY_VERSION}"

  pwd     = Dir.pwd
  ext_dir = File.expand_path('ext/oboe_metal')
  lib_dir = File.expand_path('lib')
  symlink = File.expand_path('lib/oboe_metal.so')
  so_file = File.expand_path('ext/oboe_metal/oboe_metal.so')

  Dir.chdir ext_dir
  cmd = [ Gem.ruby, 'extconf.rb']
  sh cmd.join(' ')
  sh '/usr/bin/env make'
  File.delete symlink if File.exist? symlink

  if File.exists? so_file
    File.symlink so_file, symlink
    Dir.chdir pwd
    puts "== Extension built and symlink'd to #{symlink}"
  else
    Dir.chdir pwd
    puts "!! Extension failed to build (see above).  Are the base TraceView packages installed?"
    puts "!! See https://support.tv.appneta.com/support/solutions/articles/86359"
  end
end

desc "Clean up extension build files"
task :clean do
  pwd     = Dir.pwd
  ext_dir = File.expand_path('ext/oboe_metal')
  lib_dir = File.expand_path('lib')
  symlink = File.expand_path('lib/oboe_metal.so')
  so_file = File.expand_path('ext/oboe_metal/oboe_metal.so')
  
  Dir.chdir ext_dir
  sh '/usr/bin/env make clean'
  
  Dir.chdir pwd
end

desc "Remove all built files and extensions"
task :distclean do
  pwd     = Dir.pwd
  ext_dir = File.expand_path('ext/oboe_metal')
  lib_dir = File.expand_path('lib')
  symlink = File.expand_path('lib/oboe_metal.so')
  so_file = File.expand_path('ext/oboe_metal/oboe_metal.so')
  mkmf_log = File.expand_path('ext/oboe_metal/mkmf.log')
  
  if File.exists? mkmf_log
    Dir.chdir ext_dir
    File.delete symlink if File.exist? symlink
    sh '/usr/bin/env make distclean'

    Dir.chdir pwd
  else
    puts "Nothing to distclean. (nothing built yet?)"
  end
end

desc "Rebuild the gem's c extension"
task :recompile => [ :distclean, :compile ]

task :console do
  require 'pry'
  require 'oboe'
  ARGV.clear
  Pry.start
end


