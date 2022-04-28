class Skill
  attr_accessor :id, :name

  def initialize(id:, name:)
    @id = id
    @name = name
  end

  def self.all
    [
      Skill.new(id: 1, name: "Mind reading"),
      Skill.new(id: 2, name: "Farming")
    ]
  end
end
