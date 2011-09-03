class CreateApprovalFormFields < ActiveRecord::Migration
  def change
    create_table :approval_form_fields, :force => true do |t|
      t.integer :approval_form_id
      t.string :title
      t.string :form_type
      t.text :item

      t.timestamps
    end
  end
end
