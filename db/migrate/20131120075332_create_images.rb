class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :original_name
      t.string :local

      t.timestamps
    end
  end
end
