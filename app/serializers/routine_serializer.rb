class RoutineSerializer < ActiveModel::Serializer
  attributes :id

  def attributes(*args)
    data = super
    data[:id] = object.id
    data[:name] = object.name
    data[:description] = object.description
    data[:frequency] = object.frequency
    data[:routine_date] = object.routine_date.strftime("%d/%m/%Y %H:%M %p") if object.routine_date.present?
    data
  end
end
