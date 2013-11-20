class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.string :content
      t.integer :image_id

      t.timestamps
    end
  end
end
