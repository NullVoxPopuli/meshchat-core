# frozen_string_literal: true
require 'bundler/gem_tasks'

require 'opal'

desc "Build our app to meshchat.js"
task :build do
  Opal.append_path 'home/webdev/.rvm/gems/ruby-2.3.0@meshchat/gems/meshchat-0.10.2/lib/'
  Opal.append_path 'home/webdev/.rvm/gems/ruby-2.3.0@meshchat/gems/'
  Opal.append_path 'lib/'

  File.binwrite "meshchat.js", Opal::Builder.build("./run.rb").to_s
end
