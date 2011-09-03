class CreateAlertMessages < ActiveRecord::Migration
  def change
    create_table :alert_messages do |t|
      t.references :user
      t.references :company
      t.string :text
      t.text :body
      t.timestamps
    end
    add_index :alert_messages, :user_id
    add_index :alert_messages, :company_id
  end
end
