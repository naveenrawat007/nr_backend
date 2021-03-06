class RoutineSerializer < ActiveModel::Serializer
  attributes :id

  def attributes(*args)
    data = super
    data[:id] = object.id
    data[:name] = object.name
    data[:description] = object.description
    data[:frequency] = object.frequency
    data[:active] = object.active
    data[:routine_date] = object.routine_date.strftime("%b %d, %Y") if object.routine_date.present?
    data[:routine_time] = object.routine_time.strftime("%I:%M %p")
    data[:reminder_notification_time] = object.reminder_notification_time
    data[:next_routine_date] = object.next_routine_date.strftime("%b %d, %Y at %I:%M %p") if object.next_routine_date.present?
    data
  end
end
