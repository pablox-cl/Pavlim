module VIM
  Files = %w[ vim vimrc gvimrc ]
  Dirs = %w[ autoload tmp/undo tmp/backup tmp/swap tmp/download ]
end

home = Dir.home
cwd = File.expand_path("../", __FILE__)
vim_dir = "#{home}/.vim"

task :req_dirs do
  VIM::Dirs.each do |dir|
    mkdir_p dir
  end
end

def fancy_output(message)
  n = message.length
  puts "*" * (n + 5)
  puts "*#{message.center(n + 3)}*"
  puts "*" * (n + 5)
end

task :check_curl do
  system "hash curl 2>&- || { echo >&2 \
    'curl is needed to run this, please install it first.'; }"
end

desc "Install or update pathogen"
task :pathogen_install => [:check_curl, :req_dirs] do
  fancy_output "Downloading pathogen from 'https://github.com/tpope/vim-pathogen/' ..."
  system "curl -o autoload/pathogen.vim \
    https://raw.github.com/tpope/vim-pathogen/HEAD/autoload/pathogen.vim"
end

desc "Init pavlim and update vim plugins"
task :init => [:req_dirs, :pathogen_install] do
  fancy_output "Updating all plugins"
  system "git submodule update --init"
end

desc "Update Pavlim"
task :update_pavlim do
  fancy_output "Pulling last version"
  system "git pull git://github.com/PaBLoX-CL/Pavlim.git"
end

desc "Backup original vim dotfiles"
task :backup do
  fancy_output "Backing up your old files..."
  VIM::Files.each do |file|
    file = "#{home}/.#{file}"
    next if file == vim_dir
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

def install_plugin(name, download_link=nil)

  namespace :plugin do

    desc "Install #{name} plugin"
    task name => :req_dirs do
      filename = %x(curl --silent --head #{download_link} | grep attachment).strip![/filename=(.+)/,1]
      system "curl #{download_link} > tmp/download/#{filename}"
      system "unzip -o tmp/download/#{filename} -d bundle/#{name}"
    end

  end

end

install_plugin "csapprox", "http://www.vim.org/scripts/download_script.php?src_id=10336"

desc "Link (g)vimrc to ~/.(g)vimrc"
task :link_vim_files do
  fancy_output "Linking files"
  ln_sf(cwd, vim_dir, verbose: true) unless vim_dir == cwd
  %w[ vimrc gvimrc ].each do |file|
    dest = "#{home}/.#{file}"
    src = "#{vim_dir}/#{file}"
    ln_sf(src, dest, verbose: true)
  end
end

desc "Update documentation"
task :update_docs do
  fancy_output "Updating Vim documentation..."
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
    isn't working as it should ( :"""
end

desc "Updates Pathogen, Pavlim and the plugins"
task :update => [
  :update_pavlim,
  :init,
  :default
]
