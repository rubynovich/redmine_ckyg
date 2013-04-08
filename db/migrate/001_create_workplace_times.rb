class CreateWorkplaceTimes < ActiveRecord::Migration
  def change
    create_table :workplace_times do |t|
      t.integer :user_id
      t.date :workday
      t.time :start_time
      t.time :end_time
      t.time :duration
      t.time :delay
      t.datetime :created_on
      t.datetime :updated_on
    end
  end
end
