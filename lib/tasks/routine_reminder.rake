namespace :routine_reminder do
  desc "send notification to user for their routine"
  task notification_task: :environment do

    # routines = Routine.all
    # routines.each do |routine|
    #   user = routine.user
    #   if DateTime.now > routine.next_routine_date
    #     NextRoutineDate.new(routine).call
    #     SendNotificationServices.new(routine, user).call
    #   end
    # end

  end
end
