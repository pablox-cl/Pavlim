" Source pathogen
exe 'source ' . g:pavlim_path . '/bundle/core/pathogen/autoload/pathogen.vim'

" Add a bundle
function! pavlim#add_bundle(name)
  let bundle = g:pavlim_path . "/bundle/" . a:name
  call pathogen#runtime_prepend_subdirectories(bundle)
endfunction
