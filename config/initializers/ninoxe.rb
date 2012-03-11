Chouette::ActiveRecord.establish_chouette_connection = false

class Chouette::Line

  def self.model_name
    ActiveModel::Name.new Chouette::Line, Chouette, "Line"
  end

end

class Chouette::Network

  def self.model_name
    ActiveModel::Name.new Chouette::Network, Chouette, "Network"
  end

end

class Chouette::Company

  def self.model_name
    ActiveModel::Name.new Chouette::Company, Chouette, "Company"
  end

end
