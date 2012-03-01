Chouette::ActiveRecord.establish_chouette_connection = false


class Chouette::Line

  def self.model_name
    name = "Line"
    def name.name
      self
    end
    ActiveModel::Name.new name
  end

end

class Chouette::Network
  def self.model_name
    name = "Network"
    def name.name
      self
    end
    ActiveModel::Name.new name
  end

end

class Chouette::Company
  def self.model_name
    name = "Company"
    def name.name
      self
    end
    ActiveModel::Name.new name
  end

end
