class NextRoutineDate

  def initialize(routine)
	  @routine = routine
	end

	def call
	  update_next_routine_date()
	end

	private

	attr_accessor :routine

	def update_next_routine_date()
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
	end

end
