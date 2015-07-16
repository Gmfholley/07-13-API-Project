// Class variables - should be updated for each model
///////////////////////////////////////////////////////////////////////////////////////
// returns an Array of all the classes used in this API
//
// returns an Array
function all_classes() {
  return ["Assignment", "User", "Link", "Collaborator"]
}


// Elements to return used by other functions 
//
////////////////////////////////////////////////////////////////////////////////////

// returns a loading gif image from assets
//
// returns gif Element
function return_loading_gif() {
  var gif = document.createElement("img");
  gif.src = "/loading.gif";
  gif.setAttribute("id", "loading-gif");
  gif.setAttribute("height", "100");
  gif.setAttribute("margin", "auto");
  gif.id = "loading-gif";
  return gif;
}

// returns the content div
//
// returns Element
function return_content_div(){
    return document.getElementById("contents");
}

// adds a loading gif to the contents div
//
// returns nothing
function show_loading_gif(element) {
  var gif = return_loading_gif();
  element.appendChild(gif);
  element.setAttribute("text-align", "center");
}

// toggles the class name for any number of elements
//
// class_name - String representing the class name to toggle back and forth
// also accepts an optional number of elements, comma-separated that the first line puts into an Array called args
//
// returns nothing
function toggle_class_name(class_name, array_of_Elements) {
  for (i = 0;  i < array_of_Elements.length; i++){
    array_of_Elements[i].classList.toggle(class_name);
  }
}

// returns the content div to which everything should be added
//
// returns a Div Element
function empty_and_return_content_div(){
  var content = return_content_div();
  content.innerHTML="";
  return content;
}

// insert an Element before this one
//
// newNode - Element
// referenceNoce - Element
//
// returns nothing
function insertBefore(newNode, referenceNode) {
    referenceNode.parentNode.insertBefore(newNode, referenceNode);
}


function select_element_with_options_for_each_object() {
  
  var message = document.getElementById("message");
  if (message != null){
    message.innerHTML = "";
  }
  var request = new XMLHttpRequest();
  request.open("get", get_url_this_class());
  var content = return_content_div();
  
  var previous_select = document.getElementById("object-selector");
  if (previous_select == null) {
    request.addEventListener("loadstart", show_loading_gif(content));
  }
  else{
    content.replaceChild(return_loading_gif(), previous_select);
  }
  
  request.addEventListener("load", function(){
    var s = document.createElement("select");
    s.setAttribute("id", "object-selector");
    s.style.fontSize = "100%";

    var all_objects = JSON.parse(this.response);
    for (i = 0; i < all_objects.length; i ++) {
      object = all_objects[i];
      var option = document.createElement("option");
      option.innerHTML = object.name;
      option.setAttribute("name", object.id)
      s.appendChild(option);
    }
    var content = return_content_div();
    content.replaceChild(s, document.getElementById("loading-gif"));

  });
  request.send();
}

// returns a select Element with options for each Class
//
// returns a select Element
function select_element_with_options_for_each_class() {
  var s = document.createElement("select");
  s.setAttribute("id", "class-name-selector");
  s.style.fontSize = "100%";
  all = all_classes();
  for (i = 0; i < all.length; i ++) {
    
    var option = document.createElement("option");
    option.setAttribute("value", all[i]);
    option.innerHTML=all[i];
    s.appendChild(option);
  }  
  return s;
}


// returns the div to display json in
//
// returns a div with id of json-response
function display_div_to_display_json() {
  var display = document.createElement("div");
  display.setAttribute("type", "text");
  display.setAttribute("id", "json-response");
  display.classList.add("border");
  display.classList.add("container");
  display.classList.add("api-response");
  return display;
}


// returns an input field Element
//
// returns an input field Element
function input_field(){
  var input = document.createElement("input");
  input.setAttribute("type", "text");
  input.setAttribute("name", "id");
  input.setAttribute("id", "input-id");
  input.setAttribute("placeholder", "Type in an optional id number here.");
  input.setAttribute('size',input.getAttribute('placeholder').length);
  input.style.fontSize = "100%";
  return input;
}

// removes selected and show from current selection
// adds selected and show to the clicked selected
//
// returns nothing
function show_all_interface() {
  toggle_class_name("selected", [document.getElementById("show"), document.getElementsByClassName("selected")[0]]);

  
  var content = empty_and_return_content_div();
  var submit_all = document.createElement("button");
  submit_all.innerHTML = "Submit"
  submit_all.addEventListener("click", request_json_for_class_and_optional_id);
  content.appendChild(select_element_with_options_for_each_class());
  content.appendChild(input_field());
  content.appendChild(submit_all);
  content.appendChild(display_div_to_display_json());
  
}
// returns the selected class name
//
// returns a String
function get_selected_class_name(){
 return document.getElementById("class-name-selector").value; 
}

// returns the url by looking up the class and optional input field
//
// returns url
function get_url_from_class_and_optional_input_field(){
  var url = get_url_this_class(); 
  if (document.getElementById("input-id").value != "") {
    url = url + "/" + document.getElementById("input-id").value;
  }
  return url;
}

// returns the url by looking up the class and optional input field
//
// returns String
function get_url_this_class(){
  return ("/api/" + get_selected_class_name().toLowerCase() + "s");
}

// creates a JSON request to request either all or a specific object for the class selected in the drop down
//
// returns nothing
function request_json_and_fill_in_object_fields(){
    var request = new XMLHttpRequest();
    var url = get_url_from_class_and_optional_input_field();
    
    request.open("get", url);
    request.addEventListener("loadstart", show_loading_gif(document.getElementById("json-response")));
    request.addEventListener("load", change_HTML_for_object_response);
    request.send();
}

// creates a JSON request to request either all or a specific object for the class selected in the drop down
//
// returns nothing
function request_json_for_class_and_optional_id(){
    var request = new XMLHttpRequest();
    request.open("get", get_url_from_class_and_optional_input_field());
    request.addEventListener("loadstart", show_loading_gif(document.getElementById("json-response")));
    request.addEventListener("load", function(){
      document.getElementById("json-response").innerHTML = this.response;
    })
    request.send();
}


function request_json_to_delete(){
  var request = new XMLHttpRequest();
  request.open("get", "/api/" + get_selected_class_name().toLowerCase() + "/delete/" + document.getElementById("object-selector").selectedOptions[0].getAttribute("name"));
  request.addEventListener("loadstart", show_loading_gif(document.getElementById("json-response")));
  request.addEventListener("load", function(){
    var result = JSON.parse(this.response);
    if (result.length > 0) {
      document.getElementById("message").innerHTML = "Successfully deleted.  Below, are the other objects.";
      document.getElementById("json-response").innerHTML = this.response;
    }
    else{
      document.getElementById("message").innerHTML = "Could not delete.";
      document.getElementById("json-response").innerHTML = "";
    }
    
  })
  request.send();
}

function request_object_and_create_class_html_inputs(){
  remove_children("form");
  add_message_to_form();
  document.getElementById("form").action= "/" + get_selected_class_name().toLowerCase() + "/submit"
  var request = new XMLHttpRequest();
  request.open("get", get_url_this_class() + "/0");
  request.responseType = "json";
  request.addEventListener("load", function(){
    json_object = this.response;
    
    do_something_to_all_this_object_parameters(json_object, create_HTML_for_object_response);
    
    
    var submit_all = document.createElement("button");
    submit_all.innerHTML = "Submit"
    submit_all.addEventListener("click", submit_form_using_ajax);
    var content = return_content_div();
    content.appendChild(submit_all);
    content.appendChild(display_div_to_display_json());
  });
  request.send();
}

function create_or_update_interface(){
  toggle_class_name("selected", [this, document.getElementsByClassName("selected")[0]]);
  var content = empty_and_return_content_div();

  content.appendChild(select_element_with_options_for_each_class());
  document.getElementById("class-name-selector").addEventListener("change", request_object_and_create_class_html_inputs)
  content.appendChild(input_field());
  var submit = document.createElement("button");
  submit.innerHTML = "Get Record"
  submit.addEventListener("click", request_json_and_fill_in_object_fields);
  content.appendChild(submit);
  
  content.appendChild(create_form());
  add_message_to_form();
  
//create dummy request to get a json object so you can create html fields for them
  request_object_and_create_class_html_inputs();
}


function delete_interface(){
  toggle_class_name("selected", [document.getElementById("delete"), document.getElementsByClassName("selected")[0]]);
  var content = empty_and_return_content_div();
  var submit = document.createElement("button");
  submit.id = "delete-button";
  submit.innerHTML = "Click to delete"
  submit.addEventListener("click", request_json_to_delete);

  content.appendChild(select_element_with_options_for_each_class());
  document.getElementById("class-name-selector").addEventListener("change", select_element_with_options_for_each_object);
  select_element_with_options_for_each_object();
  content.appendChild(submit);
  content.appendChild(return_message());
  content.appendChild(display_div_to_display_json());
}

function return_message(){
  var message = document.createElement("div");
  message.id = "message";
  return message;
}

function add_message_to_form(){
  document.getElementById("form").appendChild(return_message());
}


function create_form(){
  var form = document.createElement("form");
  form.id = "form";
  form.action = "/" + get_selected_class_name().toLowerCase() + "/submit"
  return form;
}
// creates HTML 
//
// returns nothing
function create_HTML_for_object_response(object, property){
  var p = document.createElement("p");
  var label = document.createElement("label");
  label.htmlFor = property;
  label.innerHTML = property + ":";
  var input = document.createElement("input");
  input.setAttribute("type", "text");
  input.setAttribute("name", 'create_form[' + property + ']');
  input.setAttribute("id", property);
  if (object[property] != null) {
    input.setAttribute("value", object[property]);
  }
  
  input.setAttribute("placeholder", "Type in the " + property);
  input.setAttribute('size',input.getAttribute('placeholder').length);
  input.setAttribute("font-size", "100%");
  p.appendChild(label);
  p.appendChild(input);
  
  document.getElementById("form").appendChild(p);
}



// logs the response
// makes an object object of the response, corresponding to the classes that need to be updated
// updates those html elements with the value
//
// returns nothing
function change_HTML_for_object_response(){
  var n = JSON.parse(this.response);
  
  document.getElementById("json-response").innerHTML = this.response;
  do_something_to_all_this_object_parameters(n, change_HTML_to_match_parameter);
  
}

// changes the HTML of the Element of this class to this object's parameter of same name
//
// obj - Object
// parameter - String of the object's parameter and matching element id to change to save
//
// returns nothing
function change_HTML_to_match_parameter(obj, parameter){
  var element = document.getElementById(parameter);
  if (element != null) {
    element.value = obj[parameter];
  }
}

// changes the HTML of the Element of this class to this object's parameter of same name
//
// obj - Object
// parameter - String of the object's parameter and matching element id to change to save
//
// returns nothing
function clear_HTML_field(obj, parameter){
  var element = document.getElementById(parameter);
  if (element != null) {
    element.value = "";
  }
}

// do something to this object's parameters
//
// obj - javascript Object
// something - function
//
// returns nothing
function do_something_to_all_this_object_parameters(obj, something) {
  for (var property in obj) {
      if (property!="id" && (obj[property] == null || obj[property].constructor != Array)) {
        something(obj, property);
      }
  }
}
function remove_children(id){
  var myNode = document.getElementById(id);
  while (myNode.firstChild) {
      myNode.removeChild(myNode.firstChild);
  }
}

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
  kvpairs.push("create_form[id]=" + document.getElementById("input-id").value);
  var queryString = kvpairs.join("&");
  
  var url = "/api" + form.getAttribute("action") + "?" + queryString;
  
  request.open("get", url);
  
  request.addEventListener("loadstart", function(){
    show_loading_gif(document.getElementById("json-response"));
    remove_children("message");
  });
  
  request.addEventListener("load", function(){
    var json = JSON.parse(this.response);
    if (json.errors.length == 0){
      
      document.getElementById("json-response").innerHTML = this.response;
      var p = document.createElement("p");
      p.innerHTML = "Successfully added!"
      document.getElementById("message").appendChild(p);
      do_something_to_all_this_object_parameters(json, clear_HTML_field);
      document.getElementById("input-id").value = "";
    }
    else {
      var message = document.getElementById("message");
      document.getElementById("json-response").innerHTML = "";
      
      for (i = 0; i < json.errors.length; i ++){
        var p = document.createElement("p");
        p.innerHTML = json.errors[i].message;
        document.getElementById("message").appendChild(p);

      }
    }
    
  });
  
  request.send(queryString);
}

window.onload = function(){
  show_all_interface();
  
  document.getElementById("show").addEventListener("click", show_all_interface);
  
  document.getElementById("create-or-update").addEventListener("click", create_or_update_interface);
  document.getElementById("delete").addEventListener("click", delete_interface);
  
}
