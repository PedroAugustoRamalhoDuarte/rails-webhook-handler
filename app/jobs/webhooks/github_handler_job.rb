class Webhooks::GithubHandlerJob < ApplicationJob
  queue_as :default

  def perform(inbound_webhook_id)
    inbound_webhook = InboundWebhook.find(inbound_webhook_id)

    # Lógica do processamento
    inbound_webhook.update!(status: :processed)
  end
end
