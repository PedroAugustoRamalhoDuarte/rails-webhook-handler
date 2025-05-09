class CreateInboundWebhooks < ActiveRecord::Migration[8.0]
  def change
    create_table :inbound_webhooks do |t|
      t.text :body
      t.string :status, default: :pending

      t.timestamps
    end
  end
end
