import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gowi_app/provider/location_provider.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  static const String id = 'map-screen';

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
   late LatLng currentLocation;
   late GoogleMapController _mapController;
   bool _location = false;
   bool lodadId =false;
   double? latitude;
   double? longitude;
   String? address;

   void initState(){
     getCurrentUser();
     super.initState();}
   void getCurrentUser(){
     setState(() {

     });

       setState(() {
         lodadId=true;

       });


   }

  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);



    setState(() {
      currentLocation = LatLng(locationData.latitude,locationData.longitude);
    });

    void onCreated(GoogleMapController controller){
      setState(() {
        _mapController = controller;
      });
    }
    return Scaffold(
      body:SafeArea(
        child: Stack(
          children: [
            GoogleMap(
                initialCameraPosition: CameraPosition(
                    target:currentLocation,zoom: 14.4746,
                ),
              zoomControlsEnabled: false,
              minMaxZoomPreference: MinMaxZoomPreference(1.5,20.8),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapType: MapType.normal,
              mapToolbarEnabled: true,
              onCameraMove: (CameraPosition position){
                  setState(() {
                    _location=true;
                  });
                locationData.onCameraMove(position);

              },
              onMapCreated: onCreated,
              onCameraIdle: (){
                setState(() {
                  _location=false;
                });
                  locationData.getMoveCamera();
              },
            ),
            Center(
              child: Container(
              height: 50,
              margin: EdgeInsets.only(bottom: 40),
              child: Image.asset('images/loc.png'),
            ),
            ),
            Center(
              child: SpinKitPulse(
                color: Colors.white,
                size: 100.0,
              ),
            ),
            Positioned(
              bottom: 0.0,
              child: Container(
                  height: 200,
                width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _location? LinearProgressIndicator(
                      backgroundColor:Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                    ):Container(),
                   Padding(
                     padding: const EdgeInsets.only(left: 10,right: 20),
                     child: TextButton.icon(
                       onPressed: () { },
                         icon: Icon(Icons.location_searching,color: Theme.of(context).primaryColor,), label:
                             Flexible(
                               child: Text( _location?'Location...':locationData.selectedAddress.featureName,
                                 overflow: TextOverflow.ellipsis,
                                 style: TextStyle(fontWeight: FontWeight.bold,
                               fontSize: 20,color: Colors.black),
                               ),
                             ),
                     ),
                   ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20,right: 20),
                      child: Text(_location?'':locationData.selectedAddress.addressLine,style: TextStyle(color: Colors.black54),),
                    ),
                    SizedBox(height: 30,),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width-40,
                        child: AbsorbPointer(
                          absorbing: _location? true:false,
                          child: FlatButton(
                            color:_location?Colors.grey:Theme.of(context).primaryColor,
                              child: Text('CONFIRM LOCATION',style: TextStyle(color: Colors.white),),
                              onPressed:(){
                              locationData.savePrefs();
                              if(lodadId==false){

                              }else{

                              }
                                  }
                                ),
                          ),
                        ),
                      ),
                  ],
                ),

                ),
            ),
          ],
        ),

      ),
    );
  }
}

