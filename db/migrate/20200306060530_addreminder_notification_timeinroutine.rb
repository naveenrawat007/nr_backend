class AddreminderNotificationTimeinroutine < ActiveRecord::Migration[5.2]
  def change
    add_column :routines, :reminder_notification_time, :integer
  end
end
