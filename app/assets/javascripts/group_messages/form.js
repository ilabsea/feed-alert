$(function(){
  messageCharCounter(140);
})

function messageCharCounter(maxLimit){
  $("#group_message_message").on('keyup', function(){
  	var countfield;
  	var field = $("#group_message_message");
    var barWidth = 280;
    fieldLength = field.val().length;
    countField = maxLimit - fieldLength;
    if(fieldLength < maxLimit){
      counterBarWidth = (fieldLength * barWidth)/maxLimit;
      $("#counter-bar").width(counterBarWidth);
      $("#counter").text(countField+" chars left");
    }else{
      $("#counter-bar").width(barWidth);
      $("#counter").text("0 char left");
    }
  });
}