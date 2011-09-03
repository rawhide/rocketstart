class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules, :force => true do |t|
      t.string :loop_group_id, :default => "0"
      t.string :type
      t.integer :owner_id, :default => 0
      t.string :title
      t.string :memo
      t.integer :start_year, :default => 0
      t.integer :start_month, :default => 0
      t.integer :start_day, :default => 0
      t.integer :start_hour, :default => 0
      t.integer :start_minute, :default => 0
      t.integer :end_year, :default => 0
      t.integer :end_month, :default => 0
      t.integer :end_day, :default => 0
      t.integer :end_hour, :default => 0
      t.integer :end_minute, :default => 0
      t.boolean :all_day
      t.integer :loop_unit, :default => 0
      t.datetime :loop_limit
      t.string :loop_week_days
      t.integer :loop_month_unit_type, :default => 0
      t.integer :loop_unit_type, :default => 0
      t.timestamps
    end
  end
end
