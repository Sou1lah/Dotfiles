require('lint').linters_by_ft = { --some of these need to be installed from package manager
  lua = {'luac'},
  python = {'ruff'},
  sh = {'bash'},
  c = {'cppcheck'},
  rust = {'clippy'},
  css = {'stylelint'},
  html = {'htmlhint'},
}

-- Some linters require a file to be saved to disk, others support linting stdin input.
-- For such linters you could also define a more aggressive autocmd,
-- for example on the InsertLeave or TextChanged events.
-- To get the filetype of a buffer you can run := vim.bo.filetype.

-- lints on close, see autocmd
