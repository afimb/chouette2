$(".compliance_check_tasks.index").ready ->
  $(".progress-bar.failed").addClass("progress-bar-danger").prepend("100%")
  $(".progress-bar.pending").addClass("progress-bar-info").prepend("10%")
  $(".progress-bar.processing").addClass("progress-bar-info").prepend("50%")
  $(".progress-bar.completed").addClass("progress-bar-success").prepend("100%")