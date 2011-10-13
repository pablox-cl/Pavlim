module VIM
  Files = %w[ vimrc gvimrc vim ]
end

directory "autoload"
home = Dir.home
cwd = File.expand_path("../", __FILE__)

task :check_curl do
  system "hash curl 2>&- || { echo >&2 \
    'curl is needed to run this, please install it first.'; }"
end

desc "Install or update pathogen"
task :pathogen_install => [:check_curl, "autoload"] do
  puts "Downloading pathogen from 'https://github.com/tpope/vim-pathogen/' ..."
  system "curl -so autoload/pathogen.vim \
    https://raw.github.com/tpope/vim-pathogen/HEAD/autoload/pathogen.vim"
  puts "Ready!"
end

desc "Init pavlim and update vim plugins"
task :init => :pathogen_install do
  puts "Updating all plugins"
  system "git submodule update --init"
end

desc "Update Pavlim"
task :update_pavlim do
  puts "Pulling last version"
  system "git pull git://github.com/PaBLoX-CL/Pavlim.git"
end

desc "Backup original vim dotfiles"
task :backup do
  puts "Backing up your old files..."
  VIM::Files.each do |file|
    file = "#{home}/.#{file}"
    if File.exists?(file)
      cp_r(file, "#{file}.old", verbose: true)
    end
  end
end

desc "Link (g)vimrc"
task :link_vimrc => :backup do
  puts "Linking files"
  %w[ vimrc gvimrc ].each do |file|
    dest = "#{home}/.#{file}"
    src = "#{cwd}/#{file}"
    ln_s(src, dest, verbose: true) unless File.exists?(dest)
  end
end

desc "Update documentation"
task :update_docs do
  puts "Updating Vim documentation..."
  system "vim -c 'call pathogen#helptags()|q'"
end

task :default => [
  :link_vimrc,
  :update_docs
]

desc "Install the bundle: get pathogen, get the plugins, backup your old files and link the new ones"
task :install => [
  :init,
  :default
]

desc "Updates Pathogen, Pavlim and the plugins"
task :update => [
  :update_pavlim,
  :init,
  :default
]
