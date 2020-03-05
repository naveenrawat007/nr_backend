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
      routine.update(start: routine.routine_date.to_time.to_i, routine_interval: 86400)
      if routine.routine_date == Date.today && (routine.routine_time.strftime("%H:%M %p") > Time.now.strftime("%H:%M %p"))
        routine.update(next_routine_date: DateTime.parse((routine.routine_date).to_s + " " + routine.routine_time.strftime("%H:%M:%S")))
      else
        routine.update(next_routine_date: DateTime.parse((routine.routine_date + 1.day).to_s + " " + routine.routine_time.strftime("%H:%M:%S")))
      end
    elsif frequency == "Weekly"
      routine.update(start: routine.routine_date.to_time.to_i, routine_interval: 604800)
      if routine.routine_date == Date.today && (routine.routine_time.strftime("%H:%M %p") > Time.now.strftime("%H:%M %p"))
        routine.update(next_routine_date: DateTime.parse((routine.routine_date).to_s + " " + routine.routine_time.strftime("%H:%M:%S")))
      else
        routine.update(next_routine_date: DateTime.parse((routine.routine_date + 1.week).to_s + " " + routine.routine_time.strftime("%H:%M:%S")))
      end
    elsif frequency == "Every Other Week"
      routine.update(next_routine_date: DateTime.parse((routine.routine_date != Date.today ? routine.routine_date : routine.routine_date + 2.weeks).to_s + " " + routine.routine_time.strftime("%H:%M:%S")), start: routine.routine_date.to_time.to_i, routine_interval: 1209600)
    elsif frequency == "Monthly"
      routine.update(next_routine_date: DateTime.parse((routine.routine_date != Date.today ? routine.routine_date : routine.routine_date + 1.months).to_s + " " + routine.routine_time.strftime("%H:%M:%S")), start: routine.routine_date.to_time.to_i, routine_interval: (routine.routine_date + 1.months).to_time.to_i - routine.routine_date.to_time.to_i)
    elsif frequency == "Every Other Month"
      routine.update(next_routine_date: DateTime.parse((routine.routine_date != Date.today ? routine.routine_date : routine.routine_date + 2.months).to_s + " " + routine.routine_time.strftime("%H:%M:%S")), start: routine.routine_date.to_time.to_i, routine_interval: (routine.routine_date + 2.months).to_time.to_i - routine.routine_date.to_time.to_i)
    elsif frequency == "Quarterly"
      routine.update(next_routine_date: DateTime.parse((routine.routine_date != Date.today ? routine.routine_date : routine.routine_date + 3.months).to_s + " " + routine.routine_time.strftime("%H:%M:%S")), start: routine.routine_date.to_time.to_i, routine_interval: (routine.routine_date + 3.months).to_time.to_i - routine.routine_date.to_time.to_i)
    elsif frequency == "Biannually"
      routine.update(next_routine_date: DateTime.parse((routine.routine_date != Date.today ? routine.routine_date : routine.routine_date + 6.months).to_s + " " + routine.routine_time.strftime("%H:%M:%S")), start: routine.routine_date.to_time.to_i, routine_interval: (routine.routine_date + 6.months).to_time.to_i - routine.routine_date.to_time.to_i)
    else
      routine.update(next_routine_date: DateTime.parse((routine.routine_date != Date.today ? routine.routine_date : routine.routine_date + 1.year).to_s + " " + routine.routine_time.strftime("%H:%M:%S")), start: routine.routine_date.to_time.to_i, routine_interval: (routine.routine_date + 1.year).to_time.to_i - routine.routine_date.to_time.to_i)
    end
	end

end
