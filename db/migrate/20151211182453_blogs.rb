class Blogs < ActiveRecord::Migration
  def change
  	create_table :blogs do |t|
  		t.integer :user_id, :null => false
  		t.text :title, :null => false
  		t.text :body, :null => false
  		t.text :slug
  		t.datetime :created_at
  		t.datetime :updated_at
  	end
  end
end
