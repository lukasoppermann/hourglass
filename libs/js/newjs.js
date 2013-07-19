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

	$('#chrome').toggleClass('title-active title-passive');
	
	if( $('#chrome').hasClass('title-active') )
	{
		$('#projects_view').find('.view-content').sortable("destroy");
		//---------------------
		// projects connected groups
		$('#projects_view').find('.view-content').sortable({
			placeholder: "project-sort-placeholder",
			forcePlaceholderSize: "forcePlaceholderSize",
			axis: "y",
			containment: ".view-content",
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
		
	}
	else
	{
		$('#projects_view').find('.view-content').sortable("destroy");
		
		//---------------------
		// sort projects
		$('#projects_view').find('.view-content').sortable({
			placeholder: "project-sort-placeholder",
			forcePlaceholderSize: "forcePlaceholderSize",
			axis: "y",
			containment: ".view-content",
			distance: 5,
			items: '.item',
			sort: function(){
			$(window).on("keydown", function( event ){
				if(event.keyCode == 27)
				{
					$('#projects_view').find('.view-content').sortable( "cancel" );
				}
			});
			}
		});	
			
	}
	
});

//---------------------
// sort projects
if( $('#chrome').hasClass('title-passive') )
{
	$('#projects_view').find('.view-content').sortable({
		placeholder: "project-sort-placeholder",
		forcePlaceholderSize: "forcePlaceholderSize",
		axis: "y",
		containment: ".view-content",
		distance: 5,
		items: '.item',
		sort: function(){
		$(window).on("keydown", function( event ){
			if(event.keyCode == 27)
			{
				$('#projects_view').find('.view-content').sortable( "cancel" );
			}
		});
		}
	});
}

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