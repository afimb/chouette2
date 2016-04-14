class Chouette::Geometry::AccessLinkPresenter
  include Chouette::Geometry::GeneralPresenter

  def initialize(access_link)
    @access_link = access_link
  end

  def geometry
    to_line_string_feature( [ @access_link.stop_area , @access_link.access_point ] )
  end
end
