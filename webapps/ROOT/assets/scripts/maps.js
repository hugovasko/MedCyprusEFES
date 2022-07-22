<script type="text/javascript">
/* For polygons coordinates */
    function chunkArray(myArray, chunk_size){
    var index = 0;
    var arrayLength = myArray.length;
    var tempArray = [];
    for (index = 0; index &lt; arrayLength; index += chunk_size) {
    myChunk = myArray.slice(index, index+chunk_size);
    tempArray.push(myChunk);
    }
    return tempArray;
    }
    
    /*Maps layers*/
    var dare = L.tileLayer('https://dh.gu.se/tiles/imperium/{z}/{x}/{y}.png', {
    minZoom: 4,
    maxZoom: 11,
    attribution: 'Map data &lt;a href="https://imperium.ahlfeldt.se/"&lt;Digital Atlas of the Roman Empire&lt;/a&lt; CC BY 4.0'
    });
    var terrain = L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Shaded_Relief/MapServer/tile/{z}/{y}/{x}', {
    attribution: 'Tiles and source Esri',
    maxZoom: 13
    });
    var watercolor = L.tileLayer('https://stamen-tiles-{s}.a.ssl.fastly.net/watercolor/{z}/{x}/{y}.{ext}', {
    attribution: 'Map tiles &lt;a href="http://stamen.com"&lt;Stamen Design&lt;/a&lt;, &lt;a href="http://creativecommons.org/licenses/by/3.0"&lt;CC BY 3.0&lt;/a&lt;, Map data &lt;a href="https://www.openstreetmap.org/copyright"&lt;OpenStreetMap&lt;/a&lt;',
    subdomains: 'abcd',
    minZoom: 1,
    maxZoom: 16,
    ext: 'jpg'
    });
    var osm = L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: 'Map data &lt;a href="https://www.openstreetmap.org/copyright"&lt;OpenStreetMap&lt;/a&lt;'
    }); 
    
    var all_places = [];
    var select_linked_places = [];
    var LeafIcon = L.Icon.extend({ options: {iconSize: [30, 30]} });
    var markerIcon = new LeafIcon({iconUrl: '../../../assets/images/marker-icon.png'});
    
    for (var [key, value] of Object.entries(points)) {
    all_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: markerIcon, id:key.substring(key.lastIndexOf("@") +1)}).bindPopup('&lt;a target="_blank" href="../epidoc/locations.html#0"&gt;'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.indexOf("#")) + '&lt;/a&gt; &lt;span class="block"&gt;Inscriptions: ' + key.substring(key.indexOf("#") +1, key.lastIndexOf("@")) + '&lt;/span&gt; &lt;span class="block"&gt;Coordinates: ' + value + '&lt;/span&gt;'));
    };
     
    var toggle_places = L.layerGroup(all_places);
    var toggle_select_linked_places = L.layerGroup(select_linked_places);
    var baseMaps = {"DARE": dare, "Terrain": terrain, "Watercolor": watercolor, "Open Street Map": osm};
    var overlayMaps = { };
    var layers = [osm, terrain, watercolor];
    var markers = all_places;
    
    function openPopupById(id){ for(var i = 0; i &lt; markers.length; ++i) { if (markers[i].options.id == id){ markers[i].openPopup(); }; }}
    
    function displayById(id){ for(var i = 0; i &lt; markers.length; ++i) { if (markers[i].options.id == id){
    toggle_select_linked_places.addLayer(markers[i]); 
    }; }}
</script>