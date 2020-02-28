class NextRoutineServices

  def initialize(routine)
	  @routine = routine
	end

	def call
	  next_routine()
	end

	private

	attr_accessor :routine

	def next_routine()
    frequency = routine.frequency
    if frequency == "Daily"
      routine.update(next_routine_date: routine.routine_date + 1.day )
    elsif frequency == "Weekly"
      routine.update(next_routine_date: routine.routine_date + 1.week )
    elsif frequency == "Every Other Week"
      routine.update(next_routine_date: routine.routine_date + 2.week )
    elsif frequency == "Monthly"
      routine.update(next_routine_date: routine.routine_date + 1.months )
    elsif frequency == "Every Other Month"
      routine.update(next_routine_date: routine.routine_date + 2.months )
    elsif frequency == "Quarterly"
      routine.update(next_routine_date: routine.routine_date + 3.months )
    elsif frequency == "Biannually"
      routine.update(next_routine_date: routine.routine_date + 6.months )
    else
      routine.update(next_routine_date: routine.routine_date + 1.year )
    end
	end

end
