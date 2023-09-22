module CentralizedAssets
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Generates an initializer for Centralized Assets"

      source_root File.expand_path('template', __dir__)

      def install
        copy_initializer
      end

      private

      def copy_initializer
        template "centralized_assets.rb", "config/initializers/centralized_assets.rb"
      end
    end
  end
end