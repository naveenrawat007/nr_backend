class RoutineSerializer < ActiveModel::Serializer
  attributes :id

  def attributes(*args)
    data = super
    data[:id] = object.id
    data[:name] = object.name
    data[:description] = object.description
    data[:frequency] = object.frequency
    data[:active] = object.active
    data[:routine_date] = object.frequency == 'Daily' ? object.routine_date.strftime("%H:%M %p") : object.routine_date.strftime("%b %d, %Y") if object.routine_date.present?
    data[:next_routine_date] = object.next_routine_date.strftime("%b %d, %Y") if object.next_routine_date.present?
    data
  end
end
