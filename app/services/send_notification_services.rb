class SendNotificationServices

  def initialize(routine, user)
	  @routine = routine
    @user = user
	end

	def call
	  routine_notifications()
	end

	private

	attr_accessor :routine, :user

  def routine_notifications()
    title = "#{routine.frequency} Reminder"
    message = "#{routine.frequency} reminder for routine #{routine.name}"
    message1 = "You've been doing great. Keep it up!"
    message2 = ""
    Sidekiq::Client.enqueue_to_in("default",routine.next_routine_date - routine.reminder_notification_time.hours, RemindRoutineWorker, user.device_type, user.device_token, message, title, routine.id, message2) if routine.reminder_notification_time.present?
    Sidekiq::Client.enqueue_to_in("default",routine.next_routine_date, RemindRoutineWorker, user.device_type, user.device_token, message, title, routine.id, message1)
    Sidekiq::Client.enqueue_to_in("default",routine.next_routine_date, NextRoutineDateWorker, routine.id)
    routine.notifications.create(description: message, title: title)
  end

end
