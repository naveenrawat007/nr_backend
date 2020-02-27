class CreateRoutines < ActiveRecord::Migration[5.2]
  def change
    create_table :routines do |t|
      t.string :name
      t.string :description
      t.datetime :routine_date
      t.datetime :next_routine_date
      t.string :frequency
      t.references :user
      t.timestamps
    end
  end
end
