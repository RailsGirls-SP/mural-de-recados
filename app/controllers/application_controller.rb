class ApplicationController < ActionController::Base
  if ENV["ACCESS_PASSWORD"].present?
    http_basic_authenticate_with name: "mural", password: ENV["ACCESS_PASSWORD"]
  end
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :admin?, :can_edit?

  private

  def admin?
    ENV["ADMIN_PASSWORD"].present? && session[:admin] == true
  end

  def can_edit?
    ENV["READ_ONLY"].blank? || admin?
  end
end
