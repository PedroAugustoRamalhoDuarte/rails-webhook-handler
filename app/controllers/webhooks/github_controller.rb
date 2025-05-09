class Webhooks::GithubController < ApplicationController

  def create
    # Segurança
    secret = ENV["SEGREDO_DO_GITHUB"] # Em production usar credentials
    verify_webhook_signature(parse_webhook_payload, secret)

    # Criar no banco de dados o Inbound webhook
    inbound_webhook = InboundWebhook.create!(body: payload)

    # Chamar o job de processamento
    Webhooks::GithubHandlerJob.perform_later(inbound_webhook.id)
  end

  private

  def parse_webhook_payload
    request.body.rewind
    JSON.parse(request.body.read)
  end


  def payload
    @payload ||= request.body.read
  end

  def verify_webhook_signature(payload_body, webhook_secret)
    signature = "sha256=" + OpenSSL::HMAC.hexdigest(
      OpenSSL::Digest.new("sha256"),
      webhook_secret,
      payload_body,
      )

    raise "Signatures didn't match!" unless Rack::Utils.secure_compare(
      signature,
      request.headers["X-Hub-Signature-256"],
      )

    true
  end
end
