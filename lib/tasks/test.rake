desc "Run sass-lint"
task :sass_lint do
  system("node_modules/.bin/sass-lint -vq") && puts("No sass linting errors!  Woo!")
end
