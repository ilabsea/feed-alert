$(function(){
  initHourPicker()
})


function initHourPicker(){
  $('.hour-picker').timepicker({
    minuteStep: 1,
    appendWidgetTo: 'body',
    showSeconds: false,
    showMeridian: false,
    defaultTime: false,
    modalBackdrop: false
  });
}