class NextRoutineDateWorker
  include Sidekiq::Worker

  def perform(routine_id)

    routine = Routine.find_by(id: routine_id)
    frequency = routine.frequency

    if frequency == "Daily"
      routine.update(next_routine_date: routine.next_routine_date + 1.days)
    elsif frequency == "Weekly"
      routine.update(next_routine_date: routine.next_routine_date + 1.weeks)
    elsif frequency == "Every Other Week"
      routine.update(next_routine_date: routine.next_routine_date + 2.weeks)
    elsif frequency == "Monthly"
      routine.update(next_routine_date: routine.next_routine_date + 1.months)
    elsif frequency == "Every Other Month"
      routine.update(next_routine_date: routine.next_routine_date + 2.months)
    elsif frequency == "Quarterly"
      routine.update(next_routine_date: routine.next_routine_date + 3.months)
    elsif frequency == "Biannually"
      routine.update(next_routine_date: routine.next_routine_date + 6.months)
    else
      routine.update(next_routine_date: routine.next_routine_date + 1.year)
    end

    SendNotificationServices.new(routine, routine.user).call

  end

end
