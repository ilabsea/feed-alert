$(function(){
  timePicker();
})

function timePicker(){
  $('#sms-alert-time .time').timepicker({
      'showDuration': true,
      'timeFormat': 'H:i'
  });

  var sms_alert_time = document.getElementById('sms-alert-time');
  if(sms_alert_time != null){
  	var sms_alert_time_pair = new Datepair(sms_alert_time); 
  } 
}