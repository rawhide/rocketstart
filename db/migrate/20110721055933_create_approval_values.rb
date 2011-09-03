class CreateApprovalValues < ActiveRecord::Migration
  def change
    create_table :approval_values, :force => true do |t|
      t.integer :approval_id
      t.integer :approval_form_field_id
      t.string :value
      t.timestamps
    end
  end
end
