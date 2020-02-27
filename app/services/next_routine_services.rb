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
    if frequency == "daily"
      routine.update(next_routine_date: routine.routine_date + 1.day )
    elsif frequency == "weekly"
      routine.update(next_routine_date: routine.routine_date + 1.week )
    elsif frequency == "every other week"
      routine.update(next_routine_date: routine.routine_date + 2.week )
    elsif frequency == "monthly"
      routine.update(next_routine_date: routine.routine_date + 1.week )
    elsif frequency == "every other month"
      routine.update(next_routine_date: routine.routine_date + 2.months )
    elsif frequency == "quarterly"
      routine.update(next_routine_date: routine.routine_date + 3.months )
    elsif frequency == "biannually"
      routine.update(next_routine_date: routine.routine_date + 6.months )
    else
      routine.update(next_routine_date: routine.routine_date + 1.year )
    end
	end

end
