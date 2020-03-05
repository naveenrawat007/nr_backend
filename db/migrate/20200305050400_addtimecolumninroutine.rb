class Addtimecolumninroutine < ActiveRecord::Migration[5.2]
  def change
    change_column :routines, :routine_date, :date
    remove_column :routines, :date, :date
    add_column :routines, :routine_time, :time
  end
end
