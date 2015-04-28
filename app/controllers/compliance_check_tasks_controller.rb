class ComplianceCheckTasksController < ChouetteController
  defaults :resource_class => ComplianceCheckTask

  belongs_to :referential

end
