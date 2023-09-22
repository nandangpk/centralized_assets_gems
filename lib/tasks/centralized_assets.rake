module CentralizedAssets
  class Railtie < ::Rails::Railtie
    rake_tasks do
      load 'tasks/centralized_assets.rake'
    end
  end
end