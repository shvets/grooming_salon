// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function checkPresence(field) {
 var hint = $F(field).length == 0 ? " This field cannot be empty!" : "";
 
 if ($(field + '_hint')) {
   $(field + '_hint').update(hint);
 }
 else {
   content = '<span class="validation" style="color:red" id="' + field + '_hint">' +
              hint + '</span>';
   new Insertion.After(field, content);
 }
}