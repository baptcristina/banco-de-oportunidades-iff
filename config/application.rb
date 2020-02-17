require_relative 'boot'

require 'rails/all'
require 'csv'
require 'devise'
require 'net/http'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ProjetoFinal
  class Application < Rails::Application
	config.i18n.default_locale = :'pt-BR'
	config.time_zone = "America/Sao_Paulo"
  	Groupdate.time_zone = false
  	config.action_view.field_error_proc = Proc.new { |html_tag, instance| 
  html_tag
}


    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
