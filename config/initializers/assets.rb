Actioncenter::Application.configure do
  config.assets.precompile = config.assets.precompile.map!{ |path| path == /(?:\/|\\|\A)application\.(css|js)$/ ? /(?<!jquery-sortable)(?:\/|\\|\A)application\.(css|js)$/ : path }
  config.assets.precompile += %w( admin/_bootstrap-theme.min.css admin/admin.css admin.js admin-head.js )
  config.assets.precompile += %w( congress-images-102x125/i/* )
end

