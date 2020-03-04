class Showroutineoncalendar < ActiveRecord::Migration[5.2]
  def change
   add_column :routines, :start, :bigint
   add_column :routines, :routine_interval, :bigint
   add_column :routines, :date, :date
  end
end
