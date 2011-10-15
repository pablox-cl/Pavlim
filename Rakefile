module VIM
  Files = %w[ vim vimrc gvimrc ]
end

directory "autoload"
home = Dir.home
cwd = File.expand_path("../", __FILE__)
vim_dir = "#{home}/.vim"

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
    if File.exists?(file) and not File.symlink?(file)
      mv file, "#{file}.old", verbose: true
    elsif File.symlink?(file)
      old_dest = File.readlink(file)
      if File.readlink(file).include? vim_dir
        ln_sf "#{vim_dir}.old/#{File.basename(old_dest)}", "#{file}.old", verbose: true
        rm file, verbose: true
      elsif
        copy_entry file, "#{file}.old"
        rm file, verbose: true
      end
    end
  end
end

desc "Link (g)vimrc"
task :link_vim_files do
  puts "Linking files"
  ln_sf(cwd, vim_dir, verbose: true) unless vim_dir == cwd
  %w[ vimrc gvimrc ].each do |file|
    dest = "#{home}/.#{file}"
    src = "#{vim_dir}/#{file}"
    ln_sf(src, dest, verbose: true) #unless File.exists?(dest)
  end
end

desc "Update documentation"
task :update_docs do
  puts "Updating Vim documentation..."
  system "vim -c 'call pathogen#helptags()|q'"
end

task :default => [
  :link_vim_files,
  :update_docs
]

desc "Install the bundle: get pathogen, get the plugins, backup your old files and link the new ones"
task :install => [
  :backup,
  :init,
  :default
] do
  puts """Your old files have been appended with .old.
  Enjoy Pavlim and please don't forget to feedback, specially if something
  isn't working ( :"""
end

desc "Updates Pathogen, Pavlim and the plugins"
task :update => [
  :update_pavlim,
  :init,
  :default
]
