class Chouette::Line
  def self.model_name
    name = "Line"
    def name.name
      self
    end
    ActiveModel::Name.new name
  end
end
