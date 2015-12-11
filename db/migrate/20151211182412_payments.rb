class Payments < ActiveRecord::Migration
  def change
  	create_table :payments do |t|
  		t.integer :user_id, :null => false
  		t.integer :pledge_id
 		t.text :paymentable_type, :null => false
		t.integer :paymentable_id, :null => false
		t.text :status
		t.text :state
		t.text :email, :null => false
		t.integer :amount, :null => false
		t.text :stripe_customer_id, :null => false
		t.text :chard_id, :null => false
		t.string :guid, :null => false
		t.string :currency, :null => false
		t.datetime :created_at
		t.datetime :updated_at
  	end
  end
end
