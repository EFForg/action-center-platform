Actioncenter::Application.configure do
  config.assets.paths << Rails.root.join("app", "assets", "fonts")
  config.assets.precompile = config.assets.precompile.map!{ |path| path == /(?:\/|\\|\A)application\.(css|js)$/ ? /(?<!jquery-sortable)(?:\/|\\|\A)application\.(css|js)$/ : path }
  config.assets.precompile += %w( admin.css admin.js )
  config.assets.precompile += %w( congress-images-102x125/i/* )
end

