class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def append_info_to_payload(payload)
    super

    payload[:remote_ip] = request.remote_ip
    payload[:user_id]   = current_user&.id
  end
end
