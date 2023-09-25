# Summary

Ruby on Rails Gem for Assets Centralization Project (NEW CDN SERVER) at PT. Tri Saudara Sentosa Industri

## Table of Content
* [Summary](https://github.com/nandangpk/centralized_assets_gems#summary)
* [Table of Content](https://github.com/nandangpk/centralized_assets_gems#table-of-content)
* [Project Status](https://github.com/nandangpk/centralized_assets_gems#project-status)
* [Installation](https://github.com/nandangpk/centralized_assets_gems#installation)
   * [Gem Installation](https://github.com/nandangpk/centralized_assets_gems#gem-installation)
   * [Generate Initializer for Gem Config](https://github.com/nandangpk/centralized_assets_gems#generate-initializer-for-gem-config)
   * [Configuration File Explanation](https://github.com/nandangpk/centralized_assets_gems#configuration-file-explanation)
   * [Import Gem in Your ApplicationRecord](https://github.com/nandangpk/centralized_assets_gems/#import-gem-in-your-applicationrecord)
* [How to Use?](https://github.com/nandangpk/centralized_assets_gems#how-to-use)
   * [Single Attachment](https://github.com/nandangpk/centralized_assets_gems#single-attachment)
      * [Model Configuration](https://github.com/nandangpk/centralized_assets_gems#model-configuration)
      * [Controller Configuration](https://github.com/nandangpk/centralized_assets_gems#controller-configuration)
      * [Methods](https://github.com/nandangpk/centralized_assets_gems#methods)
   * [Multiple Attachment](https://github.com/nandangpk/centralized_assets_gems#multiple-attachment)
      * [Model Configuration](https://github.com/nandangpk/centralized_assets_gems#model-configuration-1)
      * [Controller Configuration](https://github.com/nandangpk/centralized_assets_gems#controller-configuration-1)
      * [Methods](https://github.com/nandangpk/centralized_assets_gems#methods-1)
## Project Status
`ONGOING DEVELOPMENT`
## Installation

### Gem Installation
Add this following code in GemFile
```ruby
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
```ruby
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


### Import Gem in your ApplicationRecord

<sub>app/models/example.rb</sub>
```ruby
require 'centralized_assets'  # add this line
class ApplicationRecord < ActiveRecord::Base
  include CentralizedAssets # add this line
  ...
end

```

## How to Use?

### Single Attachment

##### Model Configuration

<sub>app/models/example.rb</sub>
```ruby
class ExampleModel < ApplicationRecord
   has_attachment :file # add this method
   ...
end
```

##### Controller Configuration

There's several way to configure the controller:
1. Permitted parameters (Recommended)
   
   <sub>app/controllers/examples_controller.rb</sub>
   ```ruby
   ...
   def create
      ...
      example = ExampleModel.new(example_params)
      example.save
      ...
   end

   def update
      ...
      example = ExampleModel.find(:params[:id])
      example.update(example_params)
      ...
   end

   private
   
   def example_params
      params.require(:example).permit(.., :attachment, ..)
   end
   ...   
   ```

   if your controller configuration using `params.require.permit`, you can generate the HTML <input> file form like this:

   <sub>app/views/examples/_form.html.erb</sub>
   ```erb
   <%= form_with(model: example, multipart: true) do |form| %>
     ...
      <%= form.file_field :attachment %>
     ...
   <% end %>
   ```
2. Manual
   
   <sub>app/controllers/examples_controller.rb</sub>
   ```ruby
   ...
   def create
      ...
      example = ExampleModel.new
      ...
      example.attachment = params[:attachment]
      ...
      example.save
      ...
   end

   def update
      ...
      example = ExampleModel.find(:params[:id])
      ...
      example.attachment = params[:attachment]
      ...
      example.save
      ...
   end
   ...   
   ```

   or you can write your controller like this:

   <sub>app/controllers/examples_controller.rb</sub>
   ```ruby
   ...
   def create
      ...
      ExampleModel.create(
         ...
         attachment: params[:attachment]
         ...
      )
      ...
   end

   def update
      ...
      example = ExampleModel.find(:params[:id])
      example.update(
         ...
         attachment: params[:attachment]
         ...
      )
      ...
   end
   ...   
   ```

   
   if your controller configuration not using `params.require.permit`, you can generate the HTML <input> file form like this:

   <sub>app/views/examples/_form.html.erb</sub>
   ```html
   <form ectype="multipart/form-data">
      ...
      <input type="file" name="attachment">
      ...
   </form>
   ```
##### Methods
```ruby
example = ExampleModel.find(params[:id])

example.file
# if attachment is present
#    return {:url => "DIRECT_URL_TO_ASSETS:string", :filename=>"ASSETS_FILENAME:string", :ext=>"ASSETS_EXTENSION:string", :size=>{:kb=>(SIZE_IN_KB:integer), :mb=>(SIZE_IN_MB:integer)}}
# else
#   return nil

example.file.present?
# if attachment is present
#    return true
# else
#   return false

example.file[:hash_key]
# if hash_key is valid
#   return hash data
# else
#   raise "Invalid hash keys, accept only: [ACCEPTED_HASH_KEYS.to_sym]"
```

### Multiple Attachment
##### Model Configuration

<sub>app/models/example.rb</sub>
```ruby
class ExampleModel < ApplicationRecord
   has_attachment :files # add this method
   ...
end
```

##### Controller Configuration

There's several way to configure the controller:
1. Permitted parameters (Recommended)
   
   <sub>app/controllers/examples_controller.rb</sub>
   ```ruby
   ...
   def create
      ...
      example = ExampleModel.new(example_params)
      example.save
      ...
   end

   def update
      ...
      example = ExampleModel.find(:params[:id])
      example.update(example_params)
      ...
   end

   private
   
   def example_params
      params.require(:example).permit(.., attachment: [], ..)
   end
   ...   
   ```

   if your controller configuration using `params.require.permit`, you can generate the HTML <input> file form like this:

   <sub>app/views/examples/_form.html.erb</sub>
   ```erb
   <%= form_with(model: example, multipart: true) do |form| %>
      ...
      <%= form.file_field :attachment, :multiple => true %>
      ...
   <% end %>
   ```
2. Manual
   
   <sub>app/controllers/examples_controller.rb</sub>
   ```ruby
   ...
   def create
      ...
      example = ExampleModel.new
      ...
      example.attachment = params[:attachment]
      ...
      example.save
      ...
   end

   def update
      ...
      example = ExampleModel.find(:params[:id])
      ...
      example.attachment = params[:attachment]
      ...
      example.save
      ...
   end
   ...   
   ```

   or you can write your controller like this:

   <sub>app/controllers/examples_controller.rb</sub>
   ```ruby
   ...
   def create
      ...
      ExampleModel.create(
         ...
         attachment: params[:attachment]
         ...
      )
      ...
   end

   def update
      ...
      example = ExampleModel.find(:params[:id])
      example.update(
         ...
         attachment: params[:attachment]
         ...
      )
      ...
   end
   ...   
   ```

   
   if your controller configuration not using `params.require.permit`, you can generate the HTML <input> file form like this:

   <sub>app/views/examples/_form.html.erb</sub>
   ```html
   <form ectype="multipart/form-data">
      ...
      <input type="file" name="attachment[]" multiple>
      ...
   </form>
   ```
##### Methods
```ruby
example = ExampleModel.find(params[:id])

example.files
# if attachment is present (atleast one)
#    return [ {:url => "DIRECT_URL_TO_ASSETS:string", :filename=>"ASSETS_FILENAME:string", :ext=>"ASSETS_EXTENSION:string", :size=>{:kb=>(SIZE_IN_KB:integer), :mb=>(SIZE_IN_MB:integer)}}, .., .. ]
# else
#   return nil

example.files.present?
# if attachment is present (atleast one)
#    return true
# else
#   return false

example.files.each do |file|
   file
#  return {:url => "DIRECT_URL_TO_ASSETS:string", :filename=>"ASSETS_FILENAME:string", :ext=>"ASSETS_EXTENSION:string", :size=>{:kb=>(SIZE_IN_KB:integer), :mb=>(SIZE_IN_MB:integer)}}

   file[:hash_key]
#  return hash data
end
```
