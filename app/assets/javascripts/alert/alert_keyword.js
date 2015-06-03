$(function(){
  buildAlertKeywordTypeahead()
  addAlertKeyword()
  removeAlertKeyword()
})

function buildAlertKeywordTypeahead(){
  var $typeAheadInput = $("#alert-keyword-typeahead")
  var urlSearch = $typeAheadInput.attr("data-url")
  var sources = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('name'),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    remote: { url: urlSearch + '?q=%QUERY', cache: false }
  });

  // initialize the bloodhound suggestion engine
  sources.initialize();

  var $alertKeywordValue = $("#alert-keyword-value")

  // instantiate the typeahead UI
  $typeAheadInput.typeahead({ hint: true, highlight: true, minLength: 1 }, {
    displayKey: 'name',
    source: sources.ttAdapter()
  })
}

function addAlertKeyword(){
  $("#add-alert-keyword").on('click', function(){
    var url = $(this).attr("href")
    var keyword = $("#alert-keyword-typeahead").val()
    if(!keyword) {
      setNotification("alert", "Please enter valid keyword")
      return false
    }
    var data = {keyword: keyword }

    $.ajax({
      method: 'POST',
      url: url,
      data: data,
      success: function(res){
        setNotification("notice", "Keyword added")
        updateAlertKeywordList(res)
      },

      error: function(){
        setNotification('error', "Could not add this keyword to alert")
        cleanAlertKeywordTypeAhead()
      }
    })
    return false
  });
}

function updateAlertKeywordList(res){
  $("#alert-keyword-list").html(res)
  cleanAlertKeywordTypeAhead()
}

function removeAlertKeywordRow(alertKeywordId){
  $alertKeywordRow = $("#alert-keyword-" + alertKeywordId)
  $alertKeywordRow.fadeOut(1000, function(){
    $alertKeywordRow.remove()
  })
}

function cleanAlertKeywordTypeAhead(){
  $("#alert-keyword-typeahead").val("")
}

function removeAlertKeyword(){
  $(document).on("click", ".remove-alert-keyword", function(){
    var alertKeywordId = $(this).attr("data-id")

    if(!confirm("Are you sure to remove this keyword ?"))
      return false

    $this = $(this)
    var url = $this.attr("href")
    $.ajax({
      url: url,
      method: 'DELETE',
      success: function(res) {
        removeAlertKeywordRow(alertKeywordId)
      },
      error: function(){
        alert("Failed to remove keyword")
      }
    })
    return false
  })
}