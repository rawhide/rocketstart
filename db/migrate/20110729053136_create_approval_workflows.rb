class CreateApprovalWorkflows < ActiveRecord::Migration
  def change
    create_table :approval_workflows do |t|
      t.references :approval
      t.references :user
      t.integer :step
      t.integer :user_type
      t.boolean :accept, :default => false
      t.timestamps
    end
  end
end
