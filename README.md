# Summary

Research and Development Ruby on Rails Gem for Assets Centralization Project at PT. Tri Saudara Sentosa Industri

## Installation

### Gem Installation
Add this following code in GemFile
```
gem 'centralized_assets', git: 'https://github.com/nandangpk/centralized_assets_gems'
```
then run `bundle install` to install the gem

### Generate Initializer for Gem Config
Run `rails generate centralized_assets:install`, it will return response :
```
   create  config/initializers/centralized_assets.rb
```
sign that we just generate a new configuration file at :

<sub>config/initializers/centralized_assets.rb</sub>
```
CentralizedAssets.configure do |config|
  config.database_url = "postgresql://username:password@localhost:5432/db_name"
  config.server_url = "..."
  config.token = "..."
end
```
### Configuration File Explanation

|config_name|detail|
|---|---|
|database_url|STILL BUG - FIXED ASAP|
|server_url|assets server host|
|token|application token for assets server|
