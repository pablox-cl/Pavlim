module VIM
  Files = %w[ vimrc gvimrc vim ]
end

directory "autoload"
home = Dir.home
cwd = File.expand_path("../", __FILE__)

task :default => [
  :init,
  :link_vimrc
]

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
  system "git submodule update --init"
end

desc "Update pavlim"
task :update_pavlim do
  system "git pull git://github.com/PaBLoX-CL/Pavlim.git"
end

desc "Update pavlim and plugins"
task :update_all => [:update_pavlim, :init] do
end

desc "Backup original vim dotfiles"
task :backup do
  VIM::Files.each do |file|
    file = "#{home}/.#{file}"
    if File.exists?(file)
      cp_r(file, "#{file}.old", verbose: true)
    end
  end
end

desc "Link (g)vimrc"
task :link_vimrc => :backup do
  %w[ vimrc gvimrc ].each do |file|
    dest = "#{home}/.#{file}"
    src = "#{cwd}/#{file}"
    ln_s(src, dest, verbose: true) unless File.exists?(dest)
  end
end
