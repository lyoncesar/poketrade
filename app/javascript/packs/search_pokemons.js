$(document).ready(function(){
  fetch_pokemon();
  cantSave();
})

function cantSave(){
  $("input").keydown(function(event) {
    hideSave();
  });
}

function hideSave() {
  elementHide("span.alert-success");
  elementHide("input.btn-primary");
  elementHide("#exchange_avg_receiving");
  elementHide("#exchange_avg_sending");
  elementHide('.avg-receiving');
  elementHide('.avg-sending');
}

function showSave(average_xp_receive = '', average_xp_send = '') {
  elementShow("span.alert-success");
  elementShow("input.btn-primary");

  showAverages(average_xp_receive, average_xp_send);
}

function showAverages(average_xp_receive = '', average_xp_send = '') {
  setElementValue('#exchange_avg_receiving', average_xp_receive);
  setElementValue('#exchange_avg_sending', average_xp_send);

  elementShow('.avg-receiving');
  elementShow('.avg-sending');
}

function fetch_pokemon() {
  $(".btn-link").on("click", function(event) {
    toggleMessages();

    const sending =  pokemonsList(".sending");
    const receiving = pokemonsList(".receiving");


    if (sending.length === 0 || receiving.length === 0) {
      elementHide("span.analyzing");
      elementShow( "span.empty-list" );
    } else {
      $.post('/trade_validate', payload(sending, receiving), function(response) {
        elementHide("span.analyzing");

        if(response.data.unknown_pokemons.length === 0) {

          if (response.data.fair_trade === true) {
            showSave(response.data.average_xp_receive, response.data.average_xp_send);
          } else {
            elementShow("span.alert-danger");
            showAverages(response.data.average_xp_receive, response.data.average_xp_send);
          }

        } else {
          unknownPokemonsAlert(response.data.unknown_pokemons);
          showAverages(response.data.average_xp_receive, response.data.average_xp_send);
        }
      }, "json");
    }
  });
}


function toggleMessages() {
  elementShow("span.analyzing");

  elementHide("span.alert-success");
  elementHide("span.alert-warning");
  elementHide("span.alert-danger");
  elementHide("span.unknown-pokemons");
  elementHide("input.btn-primary");
  elementHide("#exchange_avg_receiving");
  elementHide("#exchange_avg_sending");

  $("input:text").each(function () {
    $(this).removeClass("border-danger");
  });
}

function elementShow(element) {
  $(element).show('slow'); 
}

function elementHide(element) {
  $(element).hide('slow');
}

function pokemonsList(field_list) {
  return $(field_list).map( function() {
      if($(this).val() !== '') {
        return $(this).val();
      }
    }
  ).toArray();
}

function setElementValue(element, value) {
  $(element).val(value);
}

function unknownPokemonsAlert(list) {
  list.forEach(function(item) {
    $("input:text").each(function(input) {
      if ($(this).val().toLowerCase() == item) {
        $(this).addClass("border-danger");
        elementShow("span.unknown-pokemons");
      }
    })
  });
}

function payload(sending, receiving) {
  return {
    "data":{
      "sending": sending,
      "receiving": receiving
    }
  };
}
