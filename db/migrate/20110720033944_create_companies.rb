class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :address
      t.integer :scale
      t.string :code
      t.string :category
      t.date :expiration_date
      t.string :agency
      t.string :jis_code
      t.integer :status, :default => 1
      t.timestamps
    end
  end
end
