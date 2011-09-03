class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.references :company
      t.string  :email, :null => false
      t.string  :type
      t.string  :name
      t.string  :crypted_password
      t.string  :salt
      t.integer :status, :default => 1
      t.timestamps
    end
  end
end
