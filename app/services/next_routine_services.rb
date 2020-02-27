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
    else
      routine.update(next_routine_date: routine.routine_date + 1.month )
    end

	end
  
  
  end