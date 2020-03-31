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
    routines = user.routines.where("frequency != ? and active = ?", "Daily", true)
    routine_dates = []
    color_codes = []
    routines.each do |routine|
      frequency = routine.frequency
      new_date = routine.routine_date
      routine_month_days = no_of_days_in_month(routine.routine_date)
      if frequency == 'Weekly'
        while new_date <= end_date
            routine_dates.append({date: new_date.strftime("%d/%m/%Y"), color: color_codes.uniq << ENV["COLOR_CODE"] })
            new_date = new_date + 1.week
        end
      elsif frequency == "Every Other Week"
        while new_date <= end_date
          routine_dates.append({date: new_date.strftime("%d/%m/%Y"), color: color_codes.uniq << ENV["COLOR_CODE"] })
          new_date = new_date + 2.week
        end
      elsif frequency == "Monthly"
        while new_date <= end_date
          routine_dates.append({date: new_date.strftime("%d/%m/%Y"), color: color_codes.uniq << ENV["COLOR_CODE"] })
          if routine_month_days == 31
            days = no_of_days_in_month(new_date)
            new_date = days == 31 ? new_date + 1.months : new_date + 1.months + 1.day
          elsif routine_month_days == 30
            days = no_of_days_in_month(new_date)
            new_date = days == 30 ? new_date + 1.months : new_date + 1.months - 1.day
          else
            new_date = new_date + 1.months
          end
        end
      elsif frequency == "Every Other Month"
        while new_date <= end_date
          routine_dates.append({date: new_date.strftime("%d/%m/%Y"), color: color_codes.uniq << ENV["COLOR_CODE"] })
          new_date = new_date + 2.months
        end
      elsif frequency == "Quarterly"
        while new_date <= end_date
          routine_dates.append({date: new_date.strftime("%d/%m/%Y"), color: color_codes.uniq << ENV["COLOR_CODE"] })
          new_date = new_date + 3.months
        end
      elsif frequency == "Biannually"
        while new_date <= end_date
          routine_dates.append({date: new_date.strftime("%d/%m/%Y"), color: color_codes.uniq << ENV["COLOR_CODE"] })
          new_date = new_date + 6.months
        end
      else
        while new_date <= end_date
          routine_dates.append({date: new_date.strftime("%d/%m/%Y"), color: color_codes.uniq << ENV["COLOR_CODE"] })
          new_date = new_date + 1.year
        end
      end
    end

    routine_dates.delete_if { |d| d[:date].to_date < start_date }
    date_routines = user.routines.where("(#{selected_date} - start) % routine_interval = 0 and active = ? ", true)
    date_routines = date_routines.find_all { |routine|  Time.at(selected_date).to_date >= routine.routine_date}
    OpenStruct.new(routine_dates: routine_dates.uniq, routines: date_routines)
	end

  def no_of_days_in_month(date)
    year = date.strftime("%Y").to_i
    month = date.strftime("%m").to_i
    Date.new(year, month, -1).day
  end

end
