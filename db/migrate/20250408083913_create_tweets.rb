class CreateTweets < ActiveRecord::Migration[7.2]
  def change
    create_table :tweets do |t|
      t.references :user, null: false, foreign_key: true
      t.string :message, null: false
      
      t.timestamps
    end
  end
end
