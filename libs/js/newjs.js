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
// close jquery	
});