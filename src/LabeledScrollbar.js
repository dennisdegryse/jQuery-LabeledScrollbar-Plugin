(function( jQuery ) {
	$.widget('dede.labeledScrollbar', {
		version : '@VERSION',
		
		options : {
			scroll : null
		},

		_create : function() {
			var self = this;
			
			// lock to prevent moving the handle while dragging it
			this._lockMove = false;
			
			this.element
				.addClass('dede-labeledscrollbar');

			$('<span class="dede-labeledscrollbar-handle"></span>')
				.appendTo(this.element)
				.draggable({
					axis : 'x', 
					containment: 'parent', 
					drag : function(event, ui) {
						var percentage =  ui.position.left / (self.element.width() - $(this).width());

						self._getLabel().css({ left : ui.position.left });
						self.element.trigger('scroll', percentage);
					},
					start : function(event, ui) {
						self._lockMove = true;
						self._getLabel().fadeIn();
					},
					stop : function(event, ui) {
						self._getLabel().fadeOut();
						self._lockMove = false;
					}});
			
			$('<span class="dede-labeledscrollbar-label"></span>')
				.appendTo(this.element)
				.hide();
		},

		_getHandle : function() {
			return this.element.children('.dede-labeledscrollbar-handle');
		},

		_getLabel : function() {
			return this.element.children('.dede-labeledscrollbar-label');
		},

		/**
		 * Get or set the position of the handle
		 * 
		 * @param percentage	The position in % to set (if supplied)
		 * @returns				The current position in % (if no parameter is supplied)
		 */
		pos : function(percentage) {
			var handle = this._getHandle();
			var space = this.element.width() - handle.width(); 
			
			// GET
			if (percentage === undefined)
				return handle.position().left / space;
			
			// SET
			if (this._lockMove === true)
				return;
			
			var position = percentage * space;

			handle
				.stop(true, false)
				.animate({ left : position });
		},

		/**
		 * Get or set the label text
		 * 
		 * @param text	The text to set (if supplied)
		 * @returns		The current label text (if no parameter is supplied)
		 */
		label : function(text) {
			// GET
			if (text === undefined)
				return this._getLabel().text();
			
			// SET
			this._getLabel().text(text);
		}
	});
})( jQuery );