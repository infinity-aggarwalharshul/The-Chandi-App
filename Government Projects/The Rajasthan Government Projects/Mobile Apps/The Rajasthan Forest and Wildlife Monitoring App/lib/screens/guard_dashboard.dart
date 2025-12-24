import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../utils/app_state.dart';
import '../widgets/common.dart';
import '../widgets/modals.dart';
import 'login_screen.dart';

class GuardDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);

    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      body: Stack(
        children: [
          Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10, bottom: 20, left: 20, right: 20),
                decoration: BoxDecoration(
                  color: Color(0xFF0F172A),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
                  image: DecorationImage(
                    image: NetworkImage("https://www.transparenttextures.com/patterns/carbon-fibre.png"),
                    colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.8), BlendMode.dstATop),
                    repeat: ImageRepeat.repeat,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.yellow, width: 2),
                      ),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage("https://randomuser.me/api/portraits/men/32.jpg"),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Ofc. Vikram Singh", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          Text("Beat: Sariska Zone-4", style: TextStyle(color: Colors.greenAccent, fontSize: 10)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(FontAwesomeIcons.powerOff, color: Colors.white70, size: 18),
                      onPressed: () => state.logout(),
                    )
                  ],
                ),
              ),
              
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(20),
                  children: [
                    // AI Status
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Colors.indigo, Colors.purple]),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Color(0xFF0F172A), borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            Icon(FontAwesomeIcons.microchip, color: Colors.cyanAccent, size: 20),
                            SizedBox(width: 12),
                            Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("AI Modules Updated", style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 12)),
                                Text("v2025.12.24 • Offline NLP Ready", style: TextStyle(color: Colors.grey, fontSize: 10)),
                              ],
                            )),
                            Icon(FontAwesomeIcons.circleCheck, color: Colors.green, size: 16),
                          ],
                        ),
                      ),
                    ),

                    // Grid modules
                    GridView.count(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.1,
                      children: [
                        ActionCard(
                          title: "Apradh Panjiyan",
                          subtitle: "Secure Offense Log",
                          icon: FontAwesomeIcons.fileSignature,
                          baseColor: Colors.red,
                          onTap: () => showDialog(context: context, builder: (_) => OffenseModal()),
                        ),
                        ActionCard(
                          title: "Drishti AI",
                          subtitle: "Bio-Scan Analysis",
                          icon: FontAwesomeIcons.eye,
                          baseColor: Colors.blue,
                          onTap: () async {
                            final result = await showDialog(context: context, builder: (_) => AIScanModal());
                            if (result == true) {
                               showDialog(context: context, builder: (_) => OffenseModal());
                            }
                          },
                        ),
                        ActionCard(
                          title: "Gasti Path",
                          subtitle: "Offline GIS Map",
                          icon: FontAwesomeIcons.mapLocationDot,
                          baseColor: Colors.green,
                          onTap: () {},
                        ),
                        ActionCard(
                          title: "Aapat-Kaal",
                          subtitle: "SOS / Backup",
                          icon: FontAwesomeIcons.towerBroadcast,
                          baseColor: Colors.orange,
                          onTap: () {},
                        ),
                      ],
                    ),

                    SizedBox(height: 20),
                    
                    // Storage Sync
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border(left: BorderSide(color: Colors.yellow, width: 4)),
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text("Laghu-Bhandar Storage", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                Text("Compressed & Encrypted Local Data", style: TextStyle(fontSize: 10, color: Colors.grey)),
                              ]),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(4)),
                                child: Text("${state.localStorageUsage.toStringAsFixed(1)} KB", style: TextStyle(fontSize: 10, fontFamily: "monospace")),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: state.localStorageUsage / 5000, backgroundColor: Colors.grey.shade100, color: Colors.yellow)),
                          SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: state.isOnline ? () => state.syncData() : null,
                            icon: state.isSyncing 
                              ? SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) 
                              : Icon(FontAwesomeIcons.rotate, size: 16),
                            label: Text(state.isSyncing ? "SYNCING..." : "SYNC WITH 10T GRID"),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey.shade800, foregroundColor: Colors.white, minimumSize: Size(double.infinity, 40)),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),
                    Text("TODAY'S LEDGER", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade400, letterSpacing: 1)),
                    SizedBox(height: 10),
                    
                    if (state.logs.isEmpty)
                      Center(child: Padding(padding: EdgeInsets.all(20), child: Text("Secure Storage Empty", style: TextStyle(fontSize: 10, color: Colors.grey)))),

                    ...state.logs.map((log) => Container(
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border(left: BorderSide(color: log['synced'] == true ? Colors.green : Colors.yellow, width: 4)),
                         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4)],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Row(children: [
                              Container(padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2), decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(4)), child: Text(log['type'].toString().toUpperCase(), style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold))),
                              if (log['synced'] != true) Padding(padding: EdgeInsets.only(left: 4), child: Container(padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2), decoration: BoxDecoration(color: Colors.yellow.shade100, borderRadius: BorderRadius.circular(4)), child: Text("LOCAL", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.yellow.shade800))))
                            ]),
                            SizedBox(height: 4),
                            Row(children: [Icon(FontAwesomeIcons.key, size: 8, color: Colors.grey), SizedBox(width: 4), Text("AES-256 Encrypted Payload", style: TextStyle(fontSize: 10, color: Colors.grey, fontFamily: "monospace"))])
                          ]),
                          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                            Text(DateTime.parse(log['timestamp']).toLocal().toString().split(' ')[1].substring(0, 5), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
                            SizedBox(height: 4),
                             Row(children: [
                              if (log['has_voice'] == true) Icon(FontAwesomeIcons.microphone, size: 10, color: Colors.grey),
                              if (log['has_image'] == true) Padding(padding: EdgeInsets.only(left: 4), child: Icon(FontAwesomeIcons.image, size: 10, color: Colors.grey)),
                            ])
                          ])
                        ],
                      ),
                    )).toList(),
                    
                    SizedBox(height: 80), // Padding for bottom nav
                  ],
                ),
              ),
            ],
          ),
          
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -5))],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItem(FontAwesomeIcons.house, "Home", true),
                  _navItem(FontAwesomeIcons.robot, "Sahayak AI", false),
                  _navItem(FontAwesomeIcons.gear, "Config", false),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String text, bool active) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: active ? Colors.green.shade700 : Colors.grey.shade400, size: 20),
        SizedBox(height: 4),
        Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: active ? Colors.green.shade700 : Colors.grey.shade400)),
      ],
    );
  }
}
