class CreateUsersSchedules < ActiveRecord::Migration
  def change
    create_table :users_schedules do |t|
      t.integer :user_id
      t.integer :schedule_id

      t.timestamps
    end
  end
end
