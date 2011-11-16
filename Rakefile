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

    cwd = Dir.getwd
    tmp_dir = "#{cwd}/tmp/download"
    bundle_dir = "#{cwd}/bundle"

    def ignore_local(name)
      open("#{cwd}/.git/info/exclude", 'a') do |f|
        f << "bundle/#{name}"
      end
    end

    desc "Install #{name} plugin"
    task name => :req_dirs do

      if download_link.include?("vim.org")
        filename = %x(curl --silent --head #{download_link} | grep attachment).strip![/filename=(.+)/,1]
      else
        filename = File.basename(download_link)
      end

      system "curl #{download_link} > tmp/download/#{filename}"

      case filename
      when /\.zip$/
        system "unzip -o tmp/download/#{filename} -d bundle/#{name}"
      when /\.vim$/
        mkdir_p "#{Dir.getwd}/bundle/#{name}/plugin"
        mv "#{tmp_dir}/#{filename}", "#{bundle_dir}/#{name}/plugin/", verbose: true
      when /tar\.gz$/
        mkdir_p "#{tmp_dir}/#{name}"
        mkdir_p "#{bundle_dir}/#{name}"
        dirname = File.basename(filename, '.tar.gz')

        system "tar xf #{tmp_dir}/#{filename} -C #{tmp_dir}/#{name}"

        puts "Moving from tmp/download/#{name}/#{dirname} to bundle/#{name}"
        mv Dir["#{tmp_dir}/#{name}/#{dirname}/*"], "#{bundle_dir}/#{name}", force: true
      end

      ignore_local name

    end

  end

end

install_plugin "scratch",       "http://www.vim.org/scripts/download_script.php?src_id=2050"
install_plugin "conque-shell",  "http://conque.googlecode.com/files/conque_2.3.tar.gz"

if File.exists?(custom_rake = "#{cwd}/custom.rake")
  puts "Loading custom rake file"
  import(custom_rake)
end

desc "Link (g)vimrc to ~/.(g)vimrc"
task :link_vim_files do
  fancy_output "Linking files"
  ln_sf(cwd, vim_dir, verbose: true) unless vim_dir == cwd
  %w[ vimrc gvimrc vimrc.before vimrc.after ].each do |file|
    dest = "#{home}/.#{file}"
    src = "#{vim_dir}/#{file}"
    if File.exists?(file)
      ln_sf src, dest, verbose: true
    end
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
