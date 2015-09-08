$(function(){
  buildChannelAcceessTypeahead()
})

function buildChannelAcceessTypeahead(){
  var $userId = $("#user_id")

  var $typeAheadInput = $("#user_email")
  var urlSearch = $typeAheadInput.attr("data-url")
  var sources = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('email'),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    remote: urlSearch + '?q=%QUERY'
  });

  // initialize the bloodhound suggestion engine
  sources.initialize();

  // instantiate the typeahead UI
  $typeAheadInput.typeahead({ hint: true, highlight: true, minLength: 1 }, {
    displayKey: 'email',
    source: sources.ttAdapter(),
    templates: {
      empty: '<div class="empty-message">No result found, please retry</div>'
    }
  }).
  on('typeahead:selected', function(event, data){
    setUserData(data)
  }).
  on('typeahead:autocompleted', function(e, data){
    setUserData(data)
  });
}

function setUserData(data) {
  
}
