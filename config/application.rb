require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module InstagramApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # タイムゾーン
    config.time_zone = 'Asia/Tokyo'
    config.active_record.default_timezone = :local

    config.i18n.default_locale = :ja
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]

    # ファイルの自動生成阻止
    config.generators do |g|  # ここから追記
      g.assets false          # CSS, JavaScriptファイル生成せず
      g.skip_routes true # trueならroutes.rb変更せず、falseなら通常通り変更
      g.test_framework false  # testファイル生成せず
    end                       # ここまで

    config.cache_store = :redis_store, {
      host: 'localhost',  # Redisサーバーのホスト名
      port: 6379,         # Redisサーバーのポート
      db: 0               # 保存するデータベース 0 ~ 15の任意
    }, {
      expires_in: 90.minutes # 保存期間
    }

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
