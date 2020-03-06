$(function() {
  tagifyKeywordField();
  onsubmitKeywordSet();
})

function tagifyKeywordField() {
  var keywordField = document.getElementById("keyword_set_keyword");
  new Tagify(keywordField, {});
}

function onsubmitKeywordSet() {
  $("#keyword_set_form").submit(function(e) {
    var keywords = $('#keyword_set_keyword').val();
    if (keywords.length) {
      var transformValue = JSON.parse(keywords).map(x => x.value.trim());
      $('#keyword_set_keyword').val(transformValue.join(','));
    }
  });
}
