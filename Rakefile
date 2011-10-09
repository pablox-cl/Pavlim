directory "autoload"

task :default => [:init]

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
