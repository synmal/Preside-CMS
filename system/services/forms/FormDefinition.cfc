/**
 * A helper object for creating dynamic form
 * definitions and modififying existing definitions. Provides
 * an API abstraction for adding/modifying and removing fields, fieldsets
 * and tabs
 *
 * @autodoc
 */
component {

	public any function init( struct rawDefinition={ tabs=[] } ) {
		_setRawDefinition( arguments.rawDefinition );

		return this;
	}

	/**
	 * Returns the raw structure of the form definition.
	 * This is used by the core [[api-formsservice|Forms Service]], though
	 * you may wish to use it in your own code should you
	 * require low level access to a form definition
	 *
	 * @autodoc
	 *
	 */
	public struct function getRawDefinition() {
		return _getRawDefinition();
	}

	/**
	 * Adds a tab to the form. Any arguments passed
	 * will be treated as attributes on the tab within
	 * the form
	 *
	 * @id.hint Unique ID of the tab
	 */
	public any function addTab( required string id ) {
		var raw = _getRawDefinition();
		var tabDefinition = {};

		for( var key in arguments ) {
			tabDefinition[ key ] = IsSimpleValue( arguments[ key ] ) ? arguments[ key ] : Duplicate( arguments[ key ] );
		}

		tabDefinition.fieldSets = tabDefinition.fieldSets ?: [];

		raw.tabs = raw.tabs ?: [];
		raw.tabs.append( tabDefinition );

		return this;
	}

	/**
	 * Deletes a tab from the form that matches
	 * the given id
	 *
	 * @id.hint ID of the tab you wish to delete
	 *
	 */
	public any function deleteTab( required string id ) {
		var raw  = _getRawDefinition();
		var args = arguments;

		raw.tabs = ( raw.tabs ?: [] ).filter( function( tab ){
			return ( tab.id ?: "" ) != args.id;
		} );

		return this;
	}

	/**
	 * Modifies a tab definition. Any arguments are merged with the tab attributes
	 * for the tab matching the passed id. If the tab does not already exist, it is
	 * created.
	 *
	 * @id.hint ID of the tab you wish to modify
	 *
	 */
	public any function modifyTab( required string id ) {
		var tab = _getTab( id=arguments.id, createIfNotExists=true );

		tab.append( arguments );

		return this;
	}

	/**
	 * Adds a fieldset to the given tab. If the tab does not exist, it is created.
	 * Any arguments other than id and tab are uses as attributes for the fieldset
	 * definition.
	 *
	 * @id.hint  ID of the fieldset to create
	 * @tab.hint ID of the tab to append the fieldset to
	 *
	 */
	public any function addFieldset( required string id, required string tab ) {
		var tab = _getTab( id=arguments.tab, createIfNotExists=true );
		var fieldset = {};

		for( var key in arguments ) {
			if ( key != "tab" ) {
				fieldset[ key ] = IsSimpleValue( arguments[ key ] ) ? arguments[ key ] : Duplicate( arguments[ key ] );
			}
		}
		fieldset.fields = fieldset.fields ?: [];

		tab.fieldsets = tab.fieldsets ?: [];
		tab.fieldsets.append( fieldset );

		return this;
	}

// PRIVATE HELPERS
	private struct function _getTab( required string id, required boolean createIfNotExists ) {
		var raw = _getRawDefinition();

		raw.tabs = raw.tabs ?: [];

		for( var tab in raw.tabs ) {
			if ( ( tab.id ?: "" ) == arguments.id ) {
				return tab;
			}
		}

		addTab( id=arguments.id );

		return raw.tabs[ raw.tabs.len() ];
	}

// GETTERS AND SETTERS
	private any function _getRawDefinition() {
		return _rawDefinition;
	}
	private void function _setRawDefinition( required any rawDefinition ) {
		_rawDefinition = arguments.rawDefinition;
	}
}