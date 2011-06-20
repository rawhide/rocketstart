class CreateTokens < ActiveRecord::Migration
  def self.up
    create_table :activation_tokens do |t|
      t.string  :email, :null => false
      t.string  :token, :null => false
      t.integer :remined
      t.timestamps
    end
  end

  def self.down
    drop_table :activation_tokens
  end
end
