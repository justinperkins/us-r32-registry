var r32 = {
  possibleChassis: [ 'mkiv', 'mkv' ],
  prepare: function(editing){
    if (!editing) editing = false;
    this.editing = editing;
    var chassis = $('r32_chassis').value;
    $('javascript_warning').hide();
    $('r32_required').show();
    $('r32_optional').show();
    this.readyChassisFields(chassis);
    
    if ($('r32_preordered') && $('r32_preordered').checked) this.preorderedClicked(null, true)

    if (!this.editing){
      Event.observe('r32_chassis', 'change', this.chassisSwitched.bindAsEventListener(this));
      Event.observe('mkiv_r32_color', 'change', this.colorSwitched.bindAsEventListener(this));
      Event.observe('mkv_r32_color', 'change', this.colorSwitched.bindAsEventListener(this));
    }
    if ($('r32_preordered')) Event.observe('r32_preordered', 'click', this.preorderedClicked.bindAsEventListener(this));
  },
  chassisSwitched: function(event){
    var chassis = Event.element(event);
    this.readyChassisFields(chassis.value);
  },
  colorSwitched: function(event){
    var color = Event.element(event);
    var chassis = $('r32_chassis');
    this.showPhoto(chassis.value, color.value);
  },
  preorderedClicked: function(event, quickness){
    var preordered;
    if (event){
      preordered = Event.element(event);
    } else {
      preordered = $('r32_preordered');
    }
    
    if (preordered.checked){
      if (quickness && quickness == true){
        this.safeCall('r32_edition_number_p', 'hide');
        this.safeCall('r32_vin_p', 'hide');
        this.safeCall('r32_purchased_on_p', 'hide');
        this.safeCall('r32_optional', 'hide');
      } else {
        this.safeCall('r32_edition_number_p', 'blindUp');
        this.safeCall('r32_vin_p', 'blindUp');
        this.safeCall('r32_purchased_on_p', 'blindUp');
        this.safeCall('r32_optional', 'blindUp');
      }

      Form.disableChildFormElements('r32_edition_number_p')
      Form.disableChildFormElements('r32_vin_p');
      Form.disableChildFormElements('r32_purchased_on_p');
      Form.disableChildFormElements('r32_optional');
    } else {
      Form.enableChildFormElements('r32_edition_number_p');
      Form.enableChildFormElements('r32_vin_p');
      Form.enableChildFormElements('r32_purchased_on_p');
      Form.enableChildFormElements('r32_optional');

      this.safeCall('r32_edition_number_p', 'blindDown');
      this.safeCall('r32_vin_p', 'blindDown');
      this.safeCall('r32_purchased_on_p', 'blindDown');
      this.safeCall('r32_optional', 'blindDown');
    }
  },
  readyChassisFields: function(chassis){
    var color = 'dbp';
    if (chassis && chassis != '') color = $(chassis+'_r32_color').value;
    if (!this.editing) this.showPhoto(chassis, color);
    $$('fieldset#r32_required p').invoke('show');
    Form.enable('r32_form');
    
    this.possibleChassis.without(chassis).each(function(chassis){
      $$('fieldset p.' + chassis).invoke('hide').each(function(p){ Form.disableChildFormElements(p) });
    });
  },
  showPhoto: function(chassis, color){
    if (!color || color == '') color = 'dbp';
    if (chassis && chassis != '') {
      var photo = $('r32_photo');
      photo.setAttribute('src', '/images/' + chassis + '/' + color + '.jpg');
      photo.show();
    } else {
      this.hidePhoto();
    }
  },
  hidePhoto: function(){
    $('r32_photo').hide();
  },
  togglePictureFields: function(show_url_field){
    if (show_url_field){
      $('r32_picture_upload_field').blindUp( { duration: 0.5 } );
      window.setTimeout(function(){
        $('r32_picture_url_field').blindDown( { duration: 0.5 } );
        $('r32_picture_upload').value='';
      }, 500);
    } else {
      $('r32_picture_url_field').blindUp( { duration: 0.5 } );
      window.setTimeout(function(){
        $('r32_picture_upload_field').blindDown( { duration: 0.5 } );
        $('r32_picture_url').value='';
      }, 500);
    }
  },
  safeCall: function(element, method){
    if ($(element)) $(element)[method]();
  },
  toggleLogEntry: function(){
    var toggler = $('new_entry_toggler');
    var entry = $('add_log_entry_fieldset');
    if (entry.visible()){
      entry.blindUp();
      toggler.update('Add new entry');
    } else {
      entry.blindDown();
      toggler.update('Cancel new entry');
    }
  }
};

var Map = {
  map:null,
  r32s:$A(),
  geocoder:null,
  initialize: function(){
    if (GBrowserIsCompatible()) {
      this.map = new GMap2($('map'));
      this.map.addControl(new GSmallMapControl());
      this.map.setCenter(new GLatLng(37.857507,-95.208984), 4);
      this.geocoder = new GClientGeocoder();
      Event.observe(window, 'unload', function(){ GUnload(); });
      
      this.drawR32s();
    }
  },
  drawR32s: function(){
    var icon = new GIcon( G_DEFAULT_ICON );
    this.r32s.each( function( r32 ){
      var point = new GLatLng( r32.latitude, r32.longitude );
      icon.image = '/images/map/icons/' + r32.color.toString().toLowerCase() + '.png';
      this.map.addOverlay( this._buildOverlay( new GMarker( point, { icon: icon } ), r32 ) );
    }.bind( this ));
  },
  addR32: function( r32 ){
    this.r32s.push( r32 );
  },
  _buildOverlay: function( marker, r32 ){
    var html = '<p class="overlay" style="white-space:nowrap;">';
    html += '<a href="/r32s/show/' + r32.id + '">' + r32.chassis.toUpperCase().replace('K', 'k') + ' ' + r32.color.toUpperCase() + ' R32' + ( r32.edition_number ? ' #' + r32.edition_number : '' ) + '</a>';
    if ( r32.preordered ) html += ' (preordered)';
    html += '<br />Location: ' + r32.city + ', ' + r32.state;
    html += '<br />Mileage: ' + r32.mileage;
    html += '<br />Owned by <a href="/account/show/' + r32.ownerID + '">' + r32.owner + '</a>';
    html += '</p>';
    GEvent.addListener(marker, 'click', function(){
        marker.openInfoWindowHtml( html );
    });
	  
    return marker;
  }
};

var R32 = Class.create();
R32.prototype = {
  initialize: function( params ){
    $H( params ).each( function( pair ){
      this[ pair[0] ] = pair[1];
    });
  },
  colorAsIcon: function(){
    return '/images/map/icons/' + this.color.toString().toLowerCase() + '.png';
  }
};

Element.addMethods({
  /* helper functions for script.aculo.us */
  blindDown:    function(element, options) { new Effect.BlindDown(element, options); },
  blindUp:      function(element, options) { new Effect.BlindUp(element, options); },
  fade:         function(element, options) { new Effect.Fade(element, options); },
  appear:       function(element, options) { new Effect.Appear(element, options); },
  highlight:    function(element, options) { new Effect.Highlight(element, options); },
  pulsate:      function(element, options) { new Effect.Pulsate(element, options); }
});

Form.enableChildFormElements = function(node){
  node = $(node);
  if (node){
    var element = node.getElementsByTagName('select');
    if (element && element.length > 0) element[0].disabled = false;
    element = node.getElementsByTagName('input');
    if (element && element.length > 0) element[0].disabled = false;
  }
}
Form.disableChildFormElements = function(node){
  node = $(node);
  if (node){
    var element = node.getElementsByTagName('select');
    if (element && element.length > 0) element[0].disabled = true;
    element = node.getElementsByTagName('input');
    if (element && element.length > 0) element[0].disabled = true;
  }
}

Ajax.R32InPlaceEditor = Class.create();
Object.extend(Object.extend(Ajax.R32InPlaceEditor.prototype, Ajax.InPlaceEditor.prototype), {
  initialize: function(element, url, options) {
    this.url = url;
    this.element = $(element);

    this.options = Object.extend({
      paramName: "value",
      okButton: true,
      okText: "ok",
      cancelLink: true,
      cancelText: "cancel",
      savingText: "Saving...",
      clickToEditText: "Click to edit",
      okText: "ok",
      rows: 1,
      onComplete: function(transport, element) {
        new Effect.Highlight(element, {startcolor: this.options.highlightcolor});
      },
      onFailure: function(transport) {
        alert("Error communicating with the server: " + transport.responseText.stripTags());
      },
      callback: function(form) {
        return Form.serialize(form);
      },
      handleLineBreaks: true,
      loadingText: 'Loading...',
      savingClassName: 'inplaceeditor-saving',
      loadingClassName: 'inplaceeditor-loading',
      formClassName: 'inplaceeditor-form',
      highlightcolor: '#fff',
      highlightendcolor: "#ebebeb",
      externalControl: null,
      submitOnBlur: false,
      doubleClickToEdit: true,
      ajaxOptions: {},
      evalScripts: false
    }, options || {});
    
    if (this.options.doubleClickToEdit && !options['clickToEditText']) this.options.clickToEditText = 'Double-click to edit';

    if(!this.options.formId && this.element.id) {
      this.options.formId = this.element.id + "-inplaceeditor";
      if ($(this.options.formId)) {
        // there's already a form with that name, don't specify an id
        this.options.formId = null;
      }
    }
  
    if (this.options.externalControl) {
      this.options.externalControl = $(this.options.externalControl);
    }
  
    this.originalBackground = Element.getStyle(this.element, 'background-color');
    if (!this.originalBackground) {
      this.originalBackground = "transparent";
    }
  
    this.element.title = this.options.clickToEditText;
  
    this.onclickListener = this.enterEditMode.bindAsEventListener(this);
    this.mouseoverListener = this.enterHover.bindAsEventListener(this);
    this.mouseoutListener = this.leaveHover.bindAsEventListener(this);
    Event.observe(this.element, (this.options.doubleClickToEdit ? 'dblclick' : 'click'), this.onclickListener);
    Event.observe(this.element, 'mouseover', this.mouseoverListener);
    Event.observe(this.element, 'mouseout', this.mouseoutListener);
    if (this.options.externalControl) {
      Event.observe(this.options.externalControl, (this.options.doubleClickToEdit ? 'dblclick' : 'click'), this.onclickListener);
      Event.observe(this.options.externalControl, 'mouseover', this.mouseoverListener);
      Event.observe(this.options.externalControl, 'mouseout', this.mouseoutListener);
    }
  },
  createForm: function() {
    this.form = document.createElement("form");
    this.form.id = this.options.formId;
    Element.addClassName(this.form, this.options.formClassName)
    this.form.onsubmit = this.onSubmit.bind(this);

    this.createEditField();

    if (this.options.okButton) {
      okButton = document.createElement("input");
      okButton.type = "submit";
      okButton.value = this.options.okText;
      okButton.className = 'editor_ok_button';
      this.form.appendChild(document.createTextNode(' '));
      this.form.appendChild(okButton);
    }

    if (this.options.cancelLink) {
      cancelLink = document.createElement("a");
      cancelLink.href = "#";
      cancelLink.appendChild(document.createTextNode(this.options.cancelText));
      cancelLink.onclick = this.onclickCancel.bind(this);
      cancelLink.className = 'editor_cancel';      
      this.form.appendChild(document.createTextNode(' '));
      this.form.appendChild(cancelLink);
    }
  },
  onLoadedExternalText: function(transport) {
    Element.removeClassName(this.form, this.options.loadingClassName);
    this.editField.disabled = false;
    // only set the value to the response body if we're not doing eval scripts
    if ( !this.options.evalScripts ) this.editField.value = transport.responseText.stripTags();
    Field.scrollFreeActivate(this.editField);
  }
});