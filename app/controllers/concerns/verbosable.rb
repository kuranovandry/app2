module Verbosable
  require 'custom_record_invalid'
  DEFAULT_SEVERITY = 'error'
  DEFAULT_MESSAGE = "We're sorry, but something went wrong"
  DEFAULT_LOG_TAG = 'Error'

  extend ActiveSupport::Concern

  def handle_error(exception)
    require 'newrelic_rpm'
    NewRelic::Agent.agent.error_collector.notice_error(exception)

    if [ActionController::RoutingError, ActionController::UnknownController, ActiveRecord::RecordNotFound].include?(exception.class)
      send_response(exception, 404)
    elsif [ActiveRecord::RecordInvalid, CustomRecordInvalid].include?(exception.class)
      send_response(exception, 200)
    else
      send_response(exception, 500)
    end
  end

  def send_response(messages, status = 500)
    if messages.is_a? Array
      messages = Hash[messages.zip [DEFAULT_SEVERITY] * messages.size]
    elsif !messages.is_a? Hash
      messages = { messages => DEFAULT_SEVERITY }
    end
    json = { success: false, messages: [] }
    messages.each do |message, severity|
      log_tag = DEFAULT_LOG_TAG
      if message.is_a? Exception
        log_messsage = message.message
        log_tag = message.class.to_s
        message = message.message
      else
        log_messsage = message = message.to_s
      end
      json[:messages] << { text: message, severity: severity }
      # force to use Rails.logger, because seams like controller logger
      # is not working on heroku
      Rails.logger.tagged(log_tag) { Rails.logger.error log_messsage }
    end
    render json: json, status: status
  end
end
