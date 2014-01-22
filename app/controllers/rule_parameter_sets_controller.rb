class RuleParameterSetsController < ChouetteController
  respond_to :html
  respond_to :js, :only => [ :mode ]

  belongs_to :referential

  def new
    @rule_parameter_set = RuleParameterSet.default( @referential)
    new!
  end

  def destroy
    if @referential.rule_parameter_sets.count == 1
      flash[:alert] = "Suppression impossible, le referentiel doit compter au minimum un jeu de parametre."
      redirect_to referential_rule_parameter_sets_path( @referential )
    else
      destroy!
    end
  end

  protected

  alias_method :rule_parameter_set, :resource
end

