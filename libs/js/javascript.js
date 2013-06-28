var _tasks = $('.tasks'),
		_task = _tasks.find('.task'),
		baseColor = $('.task').first().css('background-color');
		
// run colors function
colors(baseColor);

// sortable
$(function() {
	var open = false;
   _tasks.sortable({
     placeholder: "sortable-placeholder",
		 forcePlaceholderSize: "forcePlaceholderSize",
		 axis: "y",
		 containment: "parent",
		 distance: 60,
		 items: '.task',
		 start: function(event, ui) {
			 if(ui.item.hasClass('open'))
			 {
					ui.helper.find('.body').parent().removeClass('open');
					open = true;
				}
			 ui.helper.height(ui.helper.find('.head').height());
			 $('.sortable-placeholder').height(ui.helper.find('.head').height());
		 },
		 stop: function(event, ui) {
			 colors(baseColor);
			 if(open === true)
			 {
			 	ui.item.find('.body').parent().addClass('open');
			 }
		 }
   });
   _tasks.disableSelection();
	 
 });
// editable in sortable
 $('.editable').each( function(){
     $(this)[0].onmousedown = function() {
         this.focus();
     };
 });
// open / close item
_tasks.on('click','.head', function()
{
	var item = $(this).parents('.task');
	
	if( item.hasClass('open') )
	{
		item.removeClass('open');
	}
	else
	{
		_tasks.find('.open').removeClass('open');
		item.addClass('open');
	}
	
});
// Check subtask
_tasks.on('click', '.subtask .checkbox', function(){
	var _item = $(this).parent('.subtask');
	
	if( _item.hasClass('checked') )
	{
		_item.removeClass('checked');
	}
	else
	{
		var _archive = _item.parents('.body').find('.subtask-archive');
		// add class
		_item.addClass('checked');
		// animate item
		var archiveOff = _archive.offset();
		var itemOff = _item.offset();
		var moveTop = archiveOff.top - itemOff.top;
		_item.css({'position':'absolute','top':itemOff.top}).after('<li class="subtask-hide" style="display: block; height:'+_item.outerHeight()+'px" />').animate({'top':'+='+moveTop, 'opacity':0}, 500);
		// animate hide task space
		$('.subtask-hide').animate({'height':0}, 500, function(){
			$(this).remove();
		});
	}
});