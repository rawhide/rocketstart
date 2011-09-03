class CreateMasterOfficialCompanies < ActiveRecord::Migration
  def change
    create_table :master_official_companies do |t|
      t.string :code
      t.string :name
      t.string :address
      t.string :category
      t.date :expiration_date
      t.string :agency
      t.string :jis_code
      t.timestamps
    end
    add_index :master_official_companies, :code
  end
end
