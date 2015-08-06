module ApplicationHelper
  FLASH_TYPES = {
    'warning' => 'ls-alert-warning',
    'alert' => 'ls-alert-danger',
    'alert_without_dismiss' => 'ls-alert-danger',
    'notice' => 'ls-alert-success',
    'info' => 'ls-alert-info'
  }

  def flash_message
    content = ''
    flash.each do |type, message|
      next unless FLASH_TYPES.keys.include?(type)
      content << flash_message_div(type, message) if message.present?
    end
    content.try(:html_safe)
  end

  def flash_message_div(type, message)
    return unless message.present?

    content_tag(:div, class: "ls-dismissable #{FLASH_TYPES[type]}") do
      alert = ''
      if types_with_dismiss.include?(type)
        alert = content_tag(
          :span, 'x', class: 'ls-dismiss',
          data: { ls_module: 'dismiss' }, 'aria-hidden' => 'true'
        )
      end
      "#{alert} #{message}".html_safe
    end
  end

  def types_with_dismiss
    %w(alert notice info)
  end
end
