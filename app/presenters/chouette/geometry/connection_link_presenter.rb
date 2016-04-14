class Chouette::Geometry::ConnectionLinkPresenter
  include Chouette::Geometry::GeneralPresenter

  def initialize(connection_link)
    @connection_link = connection_link
  end

  def geometry
    to_line_string_feature( @connection_link.stop_areas)
  end
end
