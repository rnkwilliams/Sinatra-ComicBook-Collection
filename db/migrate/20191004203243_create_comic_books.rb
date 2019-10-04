class CreateComicBooks < ActiveRecord::Migration
  def change
    create_table :comic_books do |t|
      t.string :publisher
      t.string :title
      t.string :volume
      t.integer :year
      t.integer :user_id
    end
  end
end
