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
    routines = user.routines.where.not(frequency: "Daily")
    routine_dates = []
    color_codes = []
    routines.each do |routine|
      frequency = routine.frequency
      new_date = routine.routine_date
      # if frequency == 'Daily'
      #   while new_date <= (end_date)
      #     routine_dates.append({date: new_date.strftime("%d/%m/%Y"), color: color_codes.uniq << "#008000" })
      #     new_date = new_date + 1.day
      #   end
      if frequency == 'Weekly'
        while new_date <= end_date
          # exist_date = routine_dates.find { |x| x[:date] == new_date.strftime("%d/%m/%Y") }
          # if exist_date.present?
          #   routine.active ? exist_date[:color] << "#008000" : exist_date[:color] << "#FF7700"
          #   new_date = new_date + 1.week
          # else
            routine_dates.append({date: new_date.strftime("%d/%m/%Y"), color: color_codes.uniq << "#008000" })
            new_date = new_date + 1.week
        end
      elsif frequency == "Every Other Week"
        while new_date <= end_date
          routine_dates.append({date: new_date.strftime("%d/%m/%Y"), color: color_codes.uniq << "#008000" })
          new_date = new_date + 2.week
        end
      elsif frequency == "Monthly"
        while new_date <= end_date
          routine_dates.append({date: new_date.strftime("%d/%m/%Y"), color: color_codes.uniq << "#008000" })
          new_date = new_date + 1.months
        end
      elsif frequency == "Every Other Month"
        while new_date <= end_date
          routine_dates.append({date: new_date.strftime("%d/%m/%Y"), color: color_codes.uniq << "#008000" })
          new_date = new_date + 2.months
        end
      elsif frequency == "Quarterly"
        while new_date <= end_date
          routine_dates.append({date: new_date.strftime("%d/%m/%Y"), color: color_codes.uniq << "#008000" })
          new_date = new_date + 3.months
        end
      elsif frequency == "Biannually"
        while new_date <= end_date
          routine_dates.append({date: new_date.strftime("%d/%m/%Y"), color: color_codes.uniq << "#008000" })
          new_date = new_date + 6.months
        end
      else
        while new_date <= end_date
          routine_dates.append({date: new_date.strftime("%d/%m/%Y"), color: color_codes.uniq << "#008000" })
          new_date = new_date + 1.year
        end
      end
    end
    routine_dates.delete_if { |d| d[:date].to_date < start_date }
    date_routines = user.routines.where("(#{selected_date} - start) % routine_interval = 0 and active = ? ", true)
    date_routines = date_routines.find_all { |routine|  Time.at(selected_date).to_date >= routine.routine_date}
    OpenStruct.new(routine_dates: routine_dates.uniq, routines: date_routines)
	end

end
