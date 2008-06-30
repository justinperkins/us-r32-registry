// Copyright 2007-2008 Justin Perkins
// The R32 registry is distributed under the GNU General Public Licens. See license.txt or http://www.gnu.org/

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
    if (event) preordered = Event.element(event);
    else preordered = $('r32_preordered');
    
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