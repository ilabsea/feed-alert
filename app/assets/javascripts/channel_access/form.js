$(function(){
  buildUserAutoComplete()
  buildProjectAutoComplete()
  // buildChannelAcceessTypeahead()
  submitProjectChannel()
})

function submitProjectChannel(){
  $(".project_channel").on('click', function(){
    projectChannelId = $(this).val();
    projectId = $(this).data('project');
    channelId = $(this).data('channel');

    $.ajax({
        url: "/project_channels/",
        method: 'POST',
        data: {project_channel: {project_id: projectId, channel_id: [channelId]}},
        success: function (data) {
          console.log(data);
        },
        error: function () {
          console.log('error');
        }
    });

  });
}

function buildUserAutoComplete(){
  var $userInput = $("#user_email");
  var urlSearch = $userInput.attr("data-url");
  $userInput.autocomplete({
    source: function (request, response) {
          $.ajax({
              url: urlSearch,
              data: { q: $userInput.val() },
              success: function (data) {
                  var transformed = $.map(data, function (el) {
                      return {
                          label: el.email,
                          id: el.id
                      };
                  });
                  response(transformed);
              },
              error: function () {
                  response([]);
              }
          });
      },
    select: function( event, ui ) {
      $('#user_id').val(ui.item.id);
    },      
    minLength: 0
  }).focus(function(){            
    $userInput.autocomplete("search");
  }).change(function(){
    console.log(change);
  });  
}

function buildProjectAutoComplete(){
  var $projectInput = $("#project_name");
  var $userId = $('#user_id');
  var urlSearch = $projectInput.attr("data-url");
  $projectInput.autocomplete({
    source: function (request, response) {
          $.ajax({
              url: urlSearch,
              data: { user_id: $userId.val(), project_name: $projectInput.val()},
              success: function (data) {
                  var transformed = $.map(data, function (el) {
                    return {
                      label: el.name,
                      id: el.id
                    };
                  });
                  response(transformed);
              },
              error: function () {
                  response([]);
              }
          });
    },
    select: function( event, ui ) {
      // $('#user_id').val(ui.item.label);
      $('#channel_access_project_id').val(ui.item.id);
    },
    minLength: 0
  }).focus(function(){            
    $projectInput.autocomplete("search");
  });  
}

function buildQueryParams(){

}


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
  $typeAheadInput.typeahead({ hint: true, highlight: true, minLength: 0 }, {
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