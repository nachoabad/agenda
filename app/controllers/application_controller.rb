class ApplicationController < ActionController::Base
  before_action :switch_locale

  private

  def switch_locale
    locale = session[:locale] || I18n.default_locale
    I18n.locale = locale
  end
end
