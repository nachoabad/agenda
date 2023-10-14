class GoogleController < ApplicationController
  before_action :authenticate_user!

  def redirect
    client = Signet::OAuth2::Client.new(client_options)

    redirect_to client.authorization_uri.to_s, allow_other_host: true
  end

  def callback
    client = Signet::OAuth2::Client.new(client_options)
    client.code = params[:code]
    response = client.fetch_access_token!
    session[:google_authorization] = response

    redirect_to google_calendars_url
  end

  def calendars
    client = Signet::OAuth2::Client.new(client_options)
    client.update!(session[:google_authorization])

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client

    @calendar_list = service.list_calendar_lists
  end

  private

  def client_options
    {
      client_id: Rails.application.credentials.google.client_id,
      client_secret: Rails.application.credentials.google.client_secret,
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR,
      redirect_uri: google_callback_url
    }
  end
end