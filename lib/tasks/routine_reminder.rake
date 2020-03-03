namespace :routine_reminder do
  desc "send notification to user for their routine"
  task notification_task: :environment do

    routines = Routine.all
    routines.each do |routine|
      user = routine.user
      if routine.next_routine_date == Date.today
        title = "Routine Reminder"
        message = "Complete your routine today"
        routine.notifications.create(description: message)
        Sidekiq::Client.enqueue_to_in("default",routine.next_routine_date, RemindRoutineWorker, user.device_type, user.device_token, message, title )
        NextRoutineServices.new(routine).call
      end
    end

  end
end
