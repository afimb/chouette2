class HubExport < ExportTask

  attr_accessor :start_date, :end_date
  enumerize :references_type, in: %w( all network line company groupofline )

  validates :start_date, presence: true , if: "end_date.present?"   
  validates :end_date, presence: true, if: "start_date.present?" 
  
  after_initialize :init_period
  
  def init_period
    unless Chouette::TimeTable.start_validity_period.nil?
      if start_date.nil?
        self.start_date = Chouette::TimeTable.start_validity_period
      end
      if end_date.nil?
        self.end_date = Chouette::TimeTable.end_validity_period
      end
    end
  end

  def action_params
    {
      "hub-export" => {
        "name" => name,
        "references_type" => references_type,
        "user_name" => user_name,
        "organisation_name" => organisation.name,
        "referential_name" => referential.name,
        "start_date" => start_date,
          "end_date" => end_date
      }
    }
  end
  
  def data_format
    "hub"
  end 

end
