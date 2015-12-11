class Pledges < ActiveRecord::Migration
  def change
  	create_table :pledges do |t|
  		t.integer :user_id, :null => false
 		t.text :pledgable_type, :null => false
		t.integer :pledgable_id, :null => false
		t.text :stripe_customer_id, :null => false
		t.string :guid, :null => false
		t.integer :amount, :null => false
		t.string :currency, :null => false
		t.text :card_fingerprint, :null => false
		t.text :card_id, :null => false
		t.datetime :created_at
		t.datetime :updated_at
  	end
  end
end
