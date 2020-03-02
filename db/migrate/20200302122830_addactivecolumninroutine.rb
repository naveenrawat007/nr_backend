class Addactivecolumninroutine < ActiveRecord::Migration[5.2]
  def change
    add_column :routines, :active, :boolean, default: true
  end
end
