class CentralizedAssetsRecord < ActiveRecord::Base
  establish_connection(CentralizedAssets.configuration.database_url)
end

class Application < CentralizedAssetsRecord
  has_many :application_files
  self.table_name = "applications"
end

class ApplicationFile < CentralizedAssetsRecord
  belongs_to :application
  has_many :application_file_items
  self.table_name = "application_files"
end

class ApplicationFileItem < CentralizedAssetsRecord
  belongs_to :application_file
  self.table_name = "application_file_items"
end