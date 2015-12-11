class Cards < ActiveRecord::Migration
  def change
  	create_table :cards do |t|
  		t.integer :user_id, :null => false
  		t.text :fingerprint, :null => false
  		t.text :card_id, :null => false
  		t.string :last4, :null => false
  		t.string :brand, :null => false
  		t.datetime :created_at
  		t.datetime :updated_at
  	end
  end
end
