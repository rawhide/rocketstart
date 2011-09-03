class CreateEmailChangeTokens < ActiveRecord::Migration
  def change
    create_table :email_change_tokens do |t|
      t.references :user
      t.string :email
      t.string :code
      t.timestamps
    end
  end
end
