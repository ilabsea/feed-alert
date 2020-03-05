$(function(){
  tagifyKeywordField();
});

function tagifyKeywordField() {
  var keywordField = document.getElementById("keyword_set_keyword");
  new Tagify(keywordField, {});
}