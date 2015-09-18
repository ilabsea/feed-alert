// $(function(){
//   buildUserAutoComplete()
//   // buildChannelAcceessTypeahead()
// })

// function buildUserAutoComplete(){
//   var $userInput = $("#user_email");
//   var urlSearch = $userInput.attr("data-url");
//   $userInput.autocomplete({
//     source: function (request, response) {
//           $.ajax({
//               url: urlSearch,
//               data: { q: $userInput.val() },
//               success: function (data) {
//                   var transformed = $.map(data, function (el) {
//                       return {
//                           label: el.email,
//                           id: el.id
//                       };
//                   });
//                   response(transformed);
//               },
//               error: function () {
//                   response([]);
//               }
//           });
//       },
//     minLength: 0
//   }).focus(function(){            
//     $userInput.autocomplete("search");
//   });  
// }


// function buildChannelAcceessTypeahead(){
//   var $userId = $("#user_id")

//   var $typeAheadInput = $("#user_email")
//   var urlSearch = $typeAheadInput.attr("data-url")
//   var sources = new Bloodhound({
//     datumTokenizer: Bloodhound.tokenizers.obj.whitespace('email'),
//     queryTokenizer: Bloodhound.tokenizers.whitespace,
//     remote: urlSearch + '?q=%QUERY'
//   });

//   // initialize the bloodhound suggestion engine
//   sources.initialize();

//   // instantiate the typeahead UI
//   $typeAheadInput.typeahead({ hint: true, highlight: true, minLength: 0 }, {
//     displayKey: 'email',
//     source: sources.ttAdapter(),
//     templates: {
//       empty: '<div class="empty-message">No result found, please retry</div>'
//     }
//   }).
//   on('typeahead:selected', function(event, data){
//     setUserData(data)
//   }).
//   on('typeahead:autocompleted', function(e, data){
//     setUserData(data)
//   }).
//   on('focus', function(){
//     $typeAheadInput.typeahead('val', ' ')
//   });
// }

// function setUserData(data) {
  
// }