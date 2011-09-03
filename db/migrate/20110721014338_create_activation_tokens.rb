class CreateActivationTokens < ActiveRecord::Migration
  def change
    create_table :activation_tokens do |t|
      t.string :email
      t.string :code
      t.timestamps
      t.boolean :remined
      t.integer :user_id
    end
  end
end
