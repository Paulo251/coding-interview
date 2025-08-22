class CreateTweets < ActiveRecord::Migration[7.2]
  def up
    create_table :tweets do |t|
      t.text :body, null: false
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end

    add_index :tweets, :user_id, if_not_exists: true
    add_index :tweets, :created_at, if_not_exists: true
  end

  def down
    drop_table :tweets
  end
end
