# frozen_string_literal: true
require_relative "centralized_assets/version"
module CentralizedAssets

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield configuration
  end
  class Configuration
    include ActiveSupport::Configurable
    config_accessor(:database_url) { ".." }
    config_accessor(:server_url) { ".." }
    config_accessor(:token) { ".." }
  end
  class Engine < ::Rails::Engine
    generators do
      require "generators/centralized_assets/install_generator"
    end
  end
    
  extend ActiveSupport::Concern
  
  module ClassMethods
    def has_attachment(attachment_name)
      case attachment_name.to_s
      when "file", "files"
        define_method(attachment_name) do
          EnableAttachment.new(self, attachment_name)
        end
        attr_accessor :attachment
        after_save do
          self.try(attachment_name.to_sym).attach(self.attachment) if self.attachment.present?
        end
      end
    end
  end
  
  class EnableAttachment
    def initialize(model, attachment_name)
      @model = model
      @attachment_name = attachment_name
    end
    
    def [](key)
      case key
      when *self.accepted_cdn_hash_keys
        self.to_s_private[key] if self.to_s_private.present?
      else
        raise "Invalid hash keys, accept only: #{accepted_cdn_hash_keys.to_s}"
      end
    end

    def to_s
      self.to_s_private.to_s
    end

    def each(&block)
      if block_given?
        return nil if self.to_a.nil? 
        self.to_a.each do |item|
          yield item
        end
      else
        raise "Expected block (do) in each, null given"
      end
    end

    def attach(file)
      require 'httparty'
      response = upload_file_to_server(file)
      #response.code == 201 ? logger.info ("Berhasil upload ke server CDN" ) : logger.info ("Gagal upload ke server CDN #{response.code}: #{response.body}")
    end
  
    def present?
      get_application_file.present?
    end

    private
    
    def single_attachment?
      @attachment_name.to_s.pluralize != @attachment_name.to_s && @attachment_name.to_s.singularize == @attachment_name.to_s
    end

    def to_a
      self.to_s_private.to_a
    end

    def cdn_url(record)
      "#{CentralizedAssets.configuration.server_url}/#{record.id}/#{record.filename}"
    end
    
    def accepted_cdn_hash_keys
      [:url, :filename, :ext, :size]
    end
    
    def cdn_hash_data(record)
      {
        url: cdn_url(record), 
        filename: record.filename.split('.').first, 
        ext: record.filename.split('.').last,
        size: {
          kb: record.byte_size.to_f / 1000,
          mb: record.byte_size.to_f / 1000000,
        }
      }
    end

    def to_s_private
        cdn_files = get_application_file
        if cdn_files.present? 
          single_attachment? ? cdn_hash_data(cdn_files.application_file_items.first) : cdn_files.application_file_items.map {|r| cdn_hash_data(r)}
        else 
          nil
        end
    end

    def get_application_file
      ActiveRecord::Base.logger.silence {
        ApplicationFile.includes(:application, :application_file_items).find_by(application: {token: CentralizedAssets.configuration.token}, application_file_items: {status: 1}, :record_id => @model.id, :record_name => @model.class.name)
      }
    end

    def upload_file_to_server(file)
      headers = {
        'token' => "#{CentralizedAssets.configuration.token}",
        'Content-Type' => 'multipart/form-data'
      }
      body = {
        file: file, 
        record_name: @model.class.name,
        record_id: @model.id,
        created_by: 1, # bisa dengan @model.created_by jika memang ada
        multiple: !self.single_attachment?
      }
      HTTParty.post("#{CentralizedAssets.configuration.server_url}/upload", headers: headers, body: body)
    end
    require 'centralized_assets/models/required_model'
  end
end
