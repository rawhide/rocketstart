class CreateApprovalForms < ActiveRecord::Migration
  def change
    create_table :approval_forms, :force => true do |t|
      t.string :title
      t.integer :user_id
      t.string :header_text
      t.string :fotter_text
      t.string :complete_text
      t.timestamps
    end
  end
end
