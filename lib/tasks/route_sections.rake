namespace :route_sections do

  def find_referential(id_or_slug)
    if id_or_slug.to_s =~ /\A\d+\Z/
      Referential.find id_or_slug.to_i
    else
      Referential.find_by slug: id_or_slug
    end
  end

  desc "Generate all RouteSections for a given Referential"
  task :create_all, [:referential] => [:environment] do |t, args|
    find_referential(args[:referential]).switch
    OsrmRouteSectionProcessor.create_all
  end

end
