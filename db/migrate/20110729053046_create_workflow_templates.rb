class CreateWorkflowTemplates < ActiveRecord::Migration
  def change
    create_table :workflow_templates do |t|
      t.references :approval_form
      t.integer :step
      t.integer :user_type
      t.timestamps
    end
  end
end
