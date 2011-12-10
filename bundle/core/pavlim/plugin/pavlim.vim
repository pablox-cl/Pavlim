" Add a bundle
function! pavlim#add_bundle(name)
  let current = expand("<sfile>:p")
  let resolved = resolve(current)
  let dir = fnamemodify(resolved, ":h")
  let bundle = dir . "/bundle/" . a:name
  call pathogen#runtime_prepend_subdirectories(bundle)
endfunction
