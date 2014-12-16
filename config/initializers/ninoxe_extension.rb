# encoding: utf-8


Rails.application.config.after_initialize do


  Chouette::TridentActiveRecord

  class Chouette::TridentActiveRecord

    # add referential relationship for objectid and localization functions
    def referential
      @referential ||= Referential.where(:slug => Apartment::Database.current_database).first!
    end

    # override prefix for good prefix in objectid generation
    def prefix
      self.referential.prefix
    end

  end

  Chouette::StopArea

  class Chouette::StopArea

    include  NinoxeExtension::ProjectionFields

    # override default_position method to add referential envelope when no stoparea is positioned
    def default_position
      # for first StopArea ... the bounds is nil , set to referential center
      Chouette::StopArea.bounds ? Chouette::StopArea.bounds.center : self.referential.envelope.center
    end


  end

  Chouette::AccessPoint

  class Chouette::AccessPoint
    include  NinoxeExtension::ProjectionFields
  end

end