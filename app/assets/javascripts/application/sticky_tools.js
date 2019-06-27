$(window).scroll(function(){
    if($(window).scrollTop() >= '100'){
        $('.tools-wrapper').removeClass('floating');
        $('.tools-wrapper').addClass('fixed');
    }

    else{
        $('.tools-wrapper').addClass('floating');
        $('.tools-wrapper').removeClass('fixed');
    }
});
