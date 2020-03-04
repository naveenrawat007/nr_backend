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
      routine.update(next_routine_date: routine.routine_date + 1.day, start: routine.date.to_time.to_i, routine_interval: 86400)
    elsif frequency == "Weekly"
      routine.update(next_routine_date: routine.routine_date + 1.week, start: routine.date.to_time.to_i, routine_interval: 604800)
    elsif frequency == "Every Other Week"
      routine.update(next_routine_date: routine.routine_date + 2.week, start: routine.date.to_time.to_i, routine_interval: 1209600)
    elsif frequency == "Monthly"
      routine.update(next_routine_date: routine.routine_date + 1.months, start: routine.date.to_time.to_i, routine_interval: (routine.date + 1.months).to_time.to_i - routine.date.to_time.to_i)
    elsif frequency == "Every Other Month"
      routine.update(next_routine_date: routine.routine_date + 2.months, start: routine.date.to_time.to_i, routine_interval: (routine.date + 2.months).to_time.to_i - routine.date.to_time.to_i)
    elsif frequency == "Quarterly"
      routine.update(next_routine_date: routine.routine_date + 3.months, start: routine.date.to_time.to_i, routine_interval: (routine.date + 3.months).to_time.to_i - routine.date.to_time.to_i)
    elsif frequency == "Biannually"
      routine.update(next_routine_date: routine.routine_date + 6.months, start: routine.date.to_time.to_i, routine_interval: (routine.date + 6.months).to_time.to_i - routine.date.to_time.to_i)
    else
      routine.update(next_routine_date: routine.routine_date + 1.year, start: routine.date.to_time.to_i, routine_interval: (routine.date + 1.year).to_time.to_i - routine.date.to_time.to_i)
    end
	end

end
