$(window).scroll(function(){
    if( ($(window).scrollTop() >= '30')){
        $('.tools-wrapper').removeClass('floating');
        $('.tools-wrapper').addClass('fixed');
    }
    else{
        $('.tools-wrapper').addClass('floating');
        $('.tools-wrapper').removeClass('fixed');
    }
});
