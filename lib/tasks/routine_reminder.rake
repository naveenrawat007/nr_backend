namespace :routine_reminder do
  desc "send notification to user for their routine"
  task notification_task: :environment do

    routines = Routine.all
    routines.each do |routine|
      user = routine.user
      if routine
        time = routine.
        Sidekiq::Client.enqueue_to_in("default",, RemindRoutineWorker, )

      elsif
      else
        
      end
    end

  end

end
