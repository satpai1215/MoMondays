class FixTimeColumn < ActiveRecord::Migration
  def change
  	add_column :events, :vote_start_time, :time
  	add_column :events, :vote_start_date, :date
  	rename_column :events, :time, :event_start_time
  	add_column :events, :event_start_date, :date
  end
end
