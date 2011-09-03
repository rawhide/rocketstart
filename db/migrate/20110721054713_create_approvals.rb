class CreateApprovals < ActiveRecord::Migration
  def change
    create_table :approvals, :force => true do |t|
      t.references :company
      t.references :approval_form
      t.integer :user_id
      t.integer :status, :default => 1
      t.timestamps
    end
  end
end
