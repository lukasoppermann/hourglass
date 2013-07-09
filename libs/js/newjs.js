$(function(){
	
//---------------------
// open today view
$('#chrome_head').on('click', '.full-circle', function(){
	var _this = $(this);
	
	_this.removeClass('active').siblings('.head-projects').addClass('active');

	$('#head_today').addClass('active').siblings('.head-title').removeClass('active');
	$('#today_view').addClass('active').siblings('.wrapper').removeClass('active');
});
//---------------------
// open projects view
$('#chrome_head').on('click', '.head-projects', function(){
	var _this = $(this);
	
	_this.removeClass('active').siblings('.full-circle').addClass('active');
	
	$('#head_projects').addClass('active').siblings('.head-title').removeClass('active');
	$('#projects_view').addClass('active').siblings('.wrapper').removeClass('active');
});
//---------------------
// clickable title
$('#head_projects').on('click', function(){
	
	if( $(this).find('.title').hasClass('active') )
	{
		$(this).find('.title').removeClass('active');
		
		$('#projects_view').find('.view-content').find('lh').removeClass('active');
		$('#projects_view').find('.view-content').find('li').addClass('active');
	}
	else
	{
		$(this).find('.title').addClass('active');
		
		$('#projects_view').find('.view-content').find('lh').addClass('active');
		$('#projects_view').find('.view-content').find('li').removeClass('active');
	}
	
});
//---------------------
// projects connected groups
$('#projects_view').find('.view-content').sortable({
	placeholder: "project-sort-placeholder",
	forcePlaceholderSize: "forcePlaceholderSize",
	axis: "y",
	containment: "parent",
	distance: 5,
	items: '.group',
	sort: function(){
	$(window).on("keydown", function( event ){
		if(event.keyCode == 27)
		{
			$('#projects_view').find('.view-content').sortable( "cancel" );
		}
	});
	}
});
//---------------------
// play pause
$('.circle-wrapper').on('click', function()
{
	if( $(this).hasClass('active') )
	{
		$('.circle-wrapper').removeClass('active');
	}
	else
	{
		$('.circle-wrapper').removeClass('active');
		$(this).addClass('active');
	}
	
});
// close jquery	
});