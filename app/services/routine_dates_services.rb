class RoutineDatesServices

  def initialize(user, start_date, end_date, selected_date)
	  @user = user
    @start_date = start_date
    @end_date = end_date
    @selected_date = selected_date
	end

	def call
	  routine()
	end

	private

	attr_accessor :user, :start_date, :end_date, :selected_date

	def routine()
    routines = @user.routines.where("(#{selected_date} - start) % routine_interval = 0 and active = ?", true)
    # routines = user.routines.where(routine_date: (start_date..end_date)).order(routine_date: :asc)
    routine_dates = []
    color_codes = []
    routines.each do |routine|
      frequency = routine.frequency
      no_days = start_date.mjd - routine.routine_date.mjd
      new_date = no_days < 0 ? routine.routine_date : routine.routine_date + no_days.days
      if frequency == 'Daily'
        while new_date <= (end_date)
          routine_dates.append({date: new_date.strftime("%d/%m/%Y"), color: "#008000" })
          new_date = new_date + 1.day
        end
      elsif frequency == 'Weekly'
        while new_date <= end_date
          # exist_date = routine_dates.find { |x| x[:date] == new_date.strftime("%d/%m/%Y") }
          # if exist_date.present?
          #   routine.active ? exist_date[:color] << "#008000" : exist_date[:color] << "#FF7700"
          #   new_date = new_date + 1.week
          # else
            routine_dates.append({date: new_date.strftime("%d/%m/%Y"), color: "#008000" })
            new_date = new_date + 1.week
        end
      elsif "Every Other Week"
        while new_date <= end_date
          routine_dates.append({date: new_date.strftime("%d/%m/%Y"), color: "#008000" })
          new_date = new_date + 2.week
        end
      elsif "Monthly"
        while new_date <= end_date
          routine_dates.append({date: new_date.strftime("%d/%m/%Y"), color: "#008000" })
          new_date = new_date + 1.months
        end
      elsif "Every Other Month"
        while new_date <= end_date
          routine_dates.append({date: new_date.strftime("%d/%m/%Y"), color: "#008000" })
          new_date = new_date + 2.months
        end
      elsif "Quarterly"
        while new_date <= end_date
          routine_dates.append({date: new_date.strftime("%d/%m/%Y"), color: "#008000" })
          new_date = new_date + 3.months
        end
      elsif "Biannually"
        while new_date <= end_date
          routine_dates.append({date: new_date.strftime("%d/%m/%Y"), color: "#008000" })
          new_date = new_date + 6.months
        end
      else
        while new_date <= end_date
          routine_dates.append({date: new_date.strftime("%d/%m/%Y"), color: "#008000" })
          new_date = new_date + 1.year
        end
      end
    end
    OpenStruct.new(routine_dates: routine_dates.uniq, routines: routines)
	end

end
