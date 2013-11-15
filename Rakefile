require 'rake'
require 'rake/clean'
require 'rake/testtask'
require 'rdoc/task'
require 'git'
require 'fileutils'

task :default => [:test]

Rake::TestTask.new do |t|
    t.test_files = FileList['lib/**/*_test.rb']
end

RDoc::Task.new do |rdoc|
  rdoc.title = "BobCat Testing API"
  rdoc.main = "README.rdoc"
  rdoc.rdoc_files.include("README.rdoc", "lib", "*.rb")
end


desc "Push latest RDocs to gh-pages."
task :ghpages => [:rerdoc] do
  g = Git.open(Dir.pwd)
  g.checkout(g.branch('gh-pages'))
  g.pull("origin", "gh-pages")
  FileUtils.rm_r("rdocs", :force => true)
  Dir.mkdir("rdocs")
  FileUtils.mv(Dir.glob("html/*"), "./rdocs", :force => true)
  FileUtils.rm_r("html", :force => true)
  g.add(".")
  g.commit_all("Update gh-pages.")
  g.push("origin", "gh-pages")
  g.checkout(g.branch('master'))
end