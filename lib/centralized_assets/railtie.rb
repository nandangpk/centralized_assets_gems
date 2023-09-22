module CentralizedAssets
  class Railtie < ::Rails::Railtie
    initializer 'centralized_assets.configure' do |app|
      CentralizedAssets.configure do |config|
        config.database_url = "postgresql://username:password@localhost:5432/db_name"
        config.server_url = "..."
        config.token = "..."
      end
    end
  end
end