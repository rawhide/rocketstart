class CreateInvitationTokens < ActiveRecord::Migration
  def change
    create_table :invitation_tokens do |t|
      t.references :company
      t.references :user
      t.integer :user_type
      t.string :code
      t.string :email
      t.timestamps
    end
  end
end
