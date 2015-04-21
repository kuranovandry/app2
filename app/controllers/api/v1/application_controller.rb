class Api::V1::ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  respond_to :json

  after_filter  :set_csrf_cookie_for_ng
  include Verbosable

  rescue_from Exception, with: :handle_error

  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  protected

  def verified_request?
    super || form_authenticity_token == request.headers['X-XSRF-TOKEN']
  end  
end
