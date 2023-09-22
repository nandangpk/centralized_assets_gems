module CentralizedAssets
  class Railtie < ::Rails::Railtie
    initializer 'centralized_assets.configure' do |app|
      CentralizedAssets.configure do |config|
        config.database_url = "postgresql://postgres:dombakuring@localhost:5432/test_storage_api_development"
        config.server_url = "..."
        config.token = "..."
      end
    end
  end
end