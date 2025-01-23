Actioncenter::Application.configure do
  # Version of your assets, change this if you want to expire all your assets.
  config.assets.version = "1.0"
  config.assets.paths << Rails.root.join("app", "assets", "fonts")
  config.assets.precompile = config.assets.precompile.map!{ |path| path == /(?:\/|\\|\A)application\.(css|js)$/ ? /(?<!jquery-sortable)(?:\/|\\|\A)application\.(css|js)$/ : path }
  config.assets.precompile += %w( admin.css admin.js )
  config.assets.precompile += %w( congress-images-102x125/i/* )
end

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )
