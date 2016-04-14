class Chouette::Geometry::AccessPointPresenter
  include Chouette::Geometry::GeneralPresenter

  def initialize(access_point)
    @access_point = access_point
  end

  def geometry
    to_point_feature( @access_point)
  end
end
