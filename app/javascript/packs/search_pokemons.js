$(document).ready(function(){
  fetch_pokemon();
})

function fetch_pokemon() {
  $(".btn-link").on("click", function(event) {
    toggleMessages();

    const sending =  pokemons_list(".sending");
    const receiving = pokemons_list(".receiving"); 

    const payload = {
      "data":{
        "sending": sending,
        "receiving": receiving
      }
    };

    if (sending.length === 0 || receiving.length === 0) {
      elementHide("span.analising");
      elementShow( "span.alert-warning" );
    } else {
      $.post('/trade_validate', payload, function(response) {
        elementHide("span.analising");
        if (response.data.fair_trade === true) {
          elementShow("span.alert-success");
          elementShow("input.btn-primary");
        } else {
          elementShow("span.alert-danger");
        }
      }, "json");
    }
  });
}

function toggleMessages() {
  elementShow("span.analising");
  elementHide("span.alert-success");
  elementHide("span.alert-warning");
  elementHide("span.alert-danger");
  elementHide("input.btn-primary");
}

function elementShow(element) {
  $(element).show('slow'); 
}

function elementHide(element) {
  $(element).hide('slow');
}

function pokemons_list(field_list) {
  return $(field_list).map( function() {
      if($(this).val() !== '') {
        return $(this).val();
      }
    }
  ).toArray();
}
