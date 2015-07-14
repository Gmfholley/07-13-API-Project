
function submit_form_using_ajax(event){
  event.preventDefault();
  var request = new XMLHttpRequest();
  
  //get the form
  var kvpairs = [];
  var form = document.getElementById("form")
  for ( var i = 0; i < form.elements.length; i++ ) {
     var e = form.elements[i];
     kvpairs.push(e.name + "=" + e.value);
  }
  var queryString = kvpairs.join("&");
  
  var url = "/api/assignment/create" + "?" + queryString;
  
  request.open("get", url);
  
  request.addEventListener("loadstart", function(){
    alert("Starting!");
  });
  
  request.addEventListener("load", function(){
    alert(this.response);
    console.log(this.response);
  });
  
  request.send(queryString);
}



window.onload = function(){
  document.getElementById("AJAX-submit").addEventListener("click", submit_form_using_ajax)
}
