#coding: utf-8
class CreateUserProfiles < ActiveRecord::Migration
  def change
    create_table :user_profiles do |t|
      t.references :user
      t.integer :sex, :default => 1
      t.string :position
      t.string :section #TODO:ohta　部署、あとでmasterにする
      t.date :birthday
      t.timestamps
    end
    add_index :user_profiles, :user_id
  end
end
