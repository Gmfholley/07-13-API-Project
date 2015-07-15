// adds a loading gif to the contents div
//
// returns nothing
function show_loading_gif(element) {
  var gif = document.createElement("img");
  gif.src = "/loading.gif";
  gif.setAttribute("id", "loading-gif");
  gif.setAttribute("height", "100");
  gif.setAttribute("margin", "auto");
  element.innerHTML = "";
  element.appendChild(gif);
  element.setAttribute("text-align", "center");
}



// toggles the class name for any number of elements
//
// class_name - String representing the class name to toggle back and forth
// also accepts an optional number of elements, comma-separated that the first line puts into an Array called args
//
// returns nothing
function toggle_class_name(class_name) {
  var args = Array.prototype.slice.call(arguments, 1);
  for (i = 0;  i < args.length; i++){
    args[i].classList.toggle(class_name);
  }
}

// returns first Element with the passed classname
//
// returns an Element DOM object
function get_first_of_this_class(class_name){
  return document.getElementsByClassName(class_name)[0];
}

// the id of the container element is the id
//
// returns an Integer of the id
function get_current_id() {
  return get_first_of_this_class("container").id
}


// creates AJAX request to get the next record
// adds event listener
// sends request
//
// returns nothing
function next_record(){
  var next_record = new XMLHttpRequest(); 
  next_record.open("get",("/product/next/" + get_current_id()));
  next_record.addEventListener("load",change_HTML_for_object_response);
  next_record.send();
}

// creates AJAX request to get the next record
// adds event listener
// sends request
//
// returns nothing
function previous_record() {
  var previous_record = new XMLHttpRequest(); 
  previous_record.open("get",("/product/previous/" + get_current_id()));
  previous_record.addEventListener("load",change_HTML_for_object_response);
  previous_record.send();
}

// returns an Array of all the classes used in this API
//
// returns an Array
function all_classes() {
  return ["Assignment", "User", "Link", "Collaborator"]
}


// returns the content div to which everything should be added
//
// returns a Div Element
function empty_and_return_content_div(){
  var content = document.getElementById("contents");
  content.innerHTML="";
  return content;
}

// returns a select Element with options for each Class
//
// returns a select Element
function select_element_with_options_for_each_class() {
  var s = document.createElement("select");
  s.setAttribute("id", "class-name-selector");
  
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
  input.setAttribute("font-size", "100%");
  return input;
}

// removes selected and show from current selection
// adds selected and show to the clicked selected
//
// returns nothing
function show_all_interface() {
  
  var submit_all = document.createElement("button");
  submit_all.innerHTML = "Submit"
  submit_all.addEventListener("click", request_json_for_class_and_optional_id);
  
  var content = empty_and_return_content_div();

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
function request_json_for_class_and_optional_id(){
    var request = new XMLHttpRequest();
    request.open("get", get_url_from_class_and_optional_input_field());
    request.addEventListener("loadstart", show_loading_gif(document.getElementById("json-response")));
    request.addEventListener("load", function(){
      document.getElementById("json-response").innerHTML = this.response;
    })
    request.send();
}


function create_or_update_interface(){
  
  var content = empty_and_return_content_div();

  content.appendChild(select_element_with_options_for_each_class());
  content.appendChild(input_field());
  
  content.appendChild(create_form());
//create dummy request to get a json object so you can create html fields for them
  
  var request = new XMLHttpRequest();
  request.open("get", get_url_this_class() + "/0");
  request.responseType = "json";
  request.addEventListener("load", function(){
    json_object = this.response;
    
    do_something_to_all_this_object_parameters(json_object, create_HTML_for_object_response);
    
    
    var submit_all = document.createElement("button");
    submit_all.innerHTML = "Submit"
    submit_all.addEventListener("click", submit_form_using_ajax);
    
    content.appendChild(submit_all);
    content.appendChild(display_div_to_display_json());
  });
  request.send();
  
  // break up the appends here so you can add the
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
  console.log(this.response);
  var n = JSON.parse(this.response);
  get_first_of_this_class("container-id").innerHTML=("Product #:" + n["id"]);
  do_something_to_all_this_object_parameters(n, change_HTML_to_match_parameter);
  document.getElementById(get_current_id()).id = n["id"];
}

// changes the HTML of the Element of this class to this object's parameter of same name
//
// obj - Object
// class_name - String of the object's parameter and matching class_name to change to save
//
// returns nothing
function change_HTML_to_match_parameter(obj, class_name){
  get_first_of_this_class(class_name).innerHTML=obj[class_name];
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
  
  var url = "/api" + form.getAttribute("action") + "?" + queryString;
  
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
  show_all_interface();
  
  document.getElementById("show").addEventListener("click", show_all_interface);
  
  document.getElementById("create-or-update").addEventListener("click", create_or_update_interface);

  
  var all = document.getElementsByClassName("tab");
  for (i = 0; i < all.length; i ++){
    all[i].addEventListener("click", display_this_one_and_hide_current);
  }
}
