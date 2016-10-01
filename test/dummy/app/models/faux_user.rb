class FauxUser
  attr_accessor :email, :password, :comments, :misc

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
end
