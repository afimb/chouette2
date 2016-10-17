class Chouette::Geometry::StopAreaPresenter
  include Chouette::Geometry::GeneralPresenter

  def initialize(stop_area)
    @stop_area = stop_area
  end

  # return line geometry based on CommercialStopPoint
  #
  def geometry
    to_point_feature( @stop_area)
  end
end
