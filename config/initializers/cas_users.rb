config = Rails.application.config_for('cas_users').symbolize_keys

CASClient::Frameworks::Rails::Filter.configure(config)
