// init quotes
function json_to_quote(type) {
  $.getJSON('/quotes/'+type+'.json', function(data) {
      var random = Math.floor(Math.random() * data.length);
      var word = data[random];
      var quote = "";
      if (typeof word["content"] === 'string') {
        quote = '<p>' + word["content"] + '</p>';
      }
      else {                        // an array of strings
        for(var i = 0; i < word["content"].length; i++) {
          quote += '<p>' + word["content"][i] + '</p>';
        }
      }
      quote += '<footer>' + word["author"];
      quote += " <cite>" + word["from"] + "</cite>";
      $('.'+type).html(quote);
  });
}

$(document).ready(function() {
    //$('.ui.progress').progress();
    if ($('.words-cn').length > 0) {
        json_to_quote('words-cn');
    }
    if ($('.words-en').length > 0) {
        json_to_quote('words-en');
    }
});

if (! /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ) {
    $(window).scroll(function() {
        if ($(this).scrollTop() > 200) {
            $('.go-top').fadeIn(600);
        } else {
            $('.go-top').fadeOut(600);
        }
    });
}

$('.go-top').click(function(event) {
    event.preventDefault();
    $('html, body').animate({scrollTop: 0}, 300);
})
