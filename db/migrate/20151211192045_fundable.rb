class Fundable < ActiveRecord::Migration
  def change
  	create_table :fundables do |t|
  		t.integer :user_id, :null => false
  		t.string :state
  		t.text :title, :null => false
  		t.text :about, :null => false
  		t.text :summary, :null => false
  		t.text :risks_challenges, :null => false
  		t.integer :duration, :null => false
  		t.integer :funding_goal, :null => false
  		t.text :slug
  		t.datetime :created_at
  		t.datetime :updated_at
  	end
  end
end
