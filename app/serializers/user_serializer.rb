class UserSerializer < ActiveModel::Serializer
  attributes :id

  def attributes(*args)
    data = super
    data[:id] = object.id
    data[:email] = object.email
    data[:first_name] = object.first_name
    data[:last_name] = object.last_name
    data[:image] = object.image.url ? ENV["PROD_URL"] + object.image.url : ""
    data[:otp] = object.otp_code
    data[:otp_verified] = object.otp_verified
    if self.instance_options[:serializer_options]
      data[:token] = self.instance_options[:serializer_options][:token]
    end
    data
  end
end
