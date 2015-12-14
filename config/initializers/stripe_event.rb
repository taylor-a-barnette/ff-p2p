StripeEvent.event_retriever = lambda do |params|
	return nil if StripeWebhook.exists?(webhook_event_id: params[:id])
	StripeWebhook.create!(
		webhook_event_id: params[:id], 
		charge_id: params[:data][:object][:charge])
	Stripe::Event.retrieve(params[:id])
end

StripeEvent.configure do |events|
	events.subscribe 'charge.dispute.created' do |event|
		StripeMailer.delay.admin_dispute_created(event.data.object.charge)
	end
=begin
	events.subscribe 'charge.succeeded' do |event|
		charge = event.data.object
		#StripeMailer.delay.receipt(charge_id)
		StripeMailer.delay.admin_charge_succeeded(charge.charge)
	end
=end
end