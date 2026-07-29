require 'net/http'

class WebhookDispatcher < ApplicationJob
  queue_as :webhooks

  MAX_RETRIES = 3
  INITIAL_BACKOFF = 5

  def perform(webhook_id, delivery_id)
    webhook = Webhook.find_by(id: webhook_id)
    delivery = WebhookDelivery.find_by(id: delivery_id)
    return unless webhook && delivery

    uri = URI.parse(webhook.url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == 'https'
    http.open_timeout = 10
    http.read_timeout = 10

    request = Net::HTTP::Post.new(uri.path.presence || '/')
    request['Content-Type'] = 'application/json'
    request['X-Webhook-Event'] = delivery.event
    request['X-Webhook-Secret'] = webhook.secret if webhook.secret.present?
    request.body = delivery.payload.to_json

    response = http.request(request)
    delivery.update!(
      response_code: response.code.to_i,
      response_body: response.body.to_s.truncate(2000),
      delivered_at: Time.current
    )
  rescue Net::OpenTimeout, Net::ReadTimeout, Errno::ECONNREFUSED => e
    retry_count = (delivery.payload || {}).dig('_retry_count') || 0
    if retry_count < MAX_RETRIES
      delay = INITIAL_BACKOFF * (2 ** retry_count)
      delivery.update!(response_code: 0, response_body: "Timeout: #{e.message} (retry #{retry_count + 1}/#{MAX_RETRIES})")
      delivery.payload['_retry_count'] = retry_count + 1
      delivery.save!
      WebhookDispatcher.set(wait: delay.seconds).perform_later(webhook_id, delivery_id)
    else
      delivery.update!(response_code: 0, response_body: "Max retries exceeded: #{e.message}", delivered_at: Time.current)
    end
  rescue => e
    delivery.update!(response_code: 0, response_body: e.message.truncate(2000), delivered_at: Time.current)
  end
end
