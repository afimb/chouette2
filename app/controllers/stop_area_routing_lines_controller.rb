class StopAreaRoutingLinesController < ChouetteController
  before_action :check_authorize, except: [:show, :index, :routing_lines_maps, :routing_lines]

  respond_to :json, :only => :index

  def index
    respond_to do |format|
      format.json { render :json => routing_lines_maps }
    end
  end

  def routing_lines_maps
    routing_lines.collect do |line|
      { :id => line.id.to_s, :name => "#{line.number} - #{line.name}" }
    end
  end

  def routing_lines
    referential.lines.all.select{ |p| p.name =~ /#{params[:q]}/i || p.number =~ /#{params[:q]}/i }
  end

end
