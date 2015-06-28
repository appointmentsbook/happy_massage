# tell the I18n library where to find your translations
I18n.config.enforce_available_locales = false
I18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
I18n.default_locale = :pt