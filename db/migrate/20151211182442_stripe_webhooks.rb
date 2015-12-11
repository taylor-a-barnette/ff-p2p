class StripeWebhooks < ActiveRecord::Migration
  def change
  	create_table :stripe_webhooks do |t|
  		t.text :charge_id
  		t.text :webhook_event_id
  		t.datetime :created_at
  		t.datetime :updated_at
  	end
  end
end
