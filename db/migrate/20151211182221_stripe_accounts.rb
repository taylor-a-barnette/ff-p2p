class StripeAccounts < ActiveRecord::Migration
  def change
  	create_table :stripe_accounts do |t|
		t.integer :user_id, :null => false
		t.text :guid, :null => false
		t.text :stripe_id, :null => false
		t.text :stripe_access_key, :null => false
		t.text :stripe_publishable_key, :null => false
		t.text :stripe_refresh_token, :null => false
  		t.datetime :created_at
  		t.datetime :updated_at
  	end
  end
end
