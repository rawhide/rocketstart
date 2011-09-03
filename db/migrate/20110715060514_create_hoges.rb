class CreateHoges < ActiveRecord::Migration
  def change
    create_table :hoges do |t|
      t.string :title

      t.timestamps
    end
  end
end
