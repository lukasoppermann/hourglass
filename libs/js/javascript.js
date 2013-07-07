var _tasks = $('.tasks'),
		_task = _tasks.find('.task'),
		baseColor = $('.task').first().css('background-color');
		
// run colors function
colors(baseColor);

_task.find('.task-heading h5').each(function(){
	var text = $(this).text();
	if( text.length > 23 )
	{
		$(this).text(text.substring(0,23).trim()+'...');
	}
});

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
		 handle: ".head",
		 start: function(event, ui) {
			 open = false;
			 if(ui.item.hasClass('open'))
			 {
					ui.helper.find('.body').parent().removeClass('open').addClass('fast-close');
					open = true;
				}
			 ui.helper.height(ui.helper.find('.head').height());
			 $('.sortable-placeholder').height(ui.helper.find('.head').height());
		 },
		 stop: function(event, ui) {
			 colors(baseColor);
			 if(open === true)
			 {
			 	ui.item.find('.body').parent().addClass('open').removeClass('fast-close');
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
	}
});
// Open settings
_tasks.on('click', '.settings', function(){
	var _settings = $('.project-settings');
	_settings.toggleClass('active');
});
// Open settings
_tasks.on('click', '.projects', function(){
	var head = $('#chrome_head').find('.task-count');
	$('.tasks').toggleClass('active');
	
	if( $('.tasks').hasClass('active') )
	{
		head.text(head.data('tasks'));
		$('.settings-small').toggleClass('active');
	}
	else
	{
		head.text(head.data('projects'));
		$('.settings-small').toggleClass('active');
	}
	
});