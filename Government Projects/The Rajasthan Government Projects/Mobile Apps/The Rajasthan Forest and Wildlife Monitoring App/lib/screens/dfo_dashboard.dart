import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../utils/app_state.dart';

class DfoDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    
    return Scaffold(
      body: Column(
        children: [
          // Top Bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(4)),
                      child: Center(child: Text("CR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: "ChitraHarsha Van Rakshak ",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade800),
                            children: [TextSpan(text: "PRO", style: TextStyle(fontSize: 9, color: Colors.grey.shade400))],
                          ),
                        ),
                        Text("Powered by VPK Ventures • Global Edition", style: TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    )
                  ],
                ),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => state.toggleNetwork(),
                      icon: Icon(FontAwesomeIcons.wifi, size: 12),
                      label: Text("Toggle Network Sim"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey.shade600,
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                    ),
                    Container(height: 24, width: 1, color: Colors.grey.shade300, margin: EdgeInsets.symmetric(horizontal: 16)),
                    Row(
                      children: [
                         Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                         SizedBox(width: 8),
                         Text("DFO Jaipur", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey.shade700)),
                      ],
                    ),
                    SizedBox(width: 16),
                    IconButton(onPressed: () => state.logout(), icon: Icon(FontAwesomeIcons.powerOff, color: Colors.grey.shade400, size: 16)),
                  ],
                )
              ],
            ),
          ),

          Expanded(
            child: Row(
              children: [
                // Sidebar
                Container(
                  width: 250,
                  color: Color(0xFF0F172A),
                  child: ListView(
                    padding: EdgeInsets.all(16),
                    children: [
                      _sidebarSection("Monitoring", [
                        _sidebarItem(FontAwesomeIcons.tableCellsLarge, "Dashboard", active: true),
                        _sidebarItem(FontAwesomeIcons.map, "GIS Live Map"),
                        _sidebarItem(FontAwesomeIcons.satelliteDish, "IoT Sensor Grid"),
                      ]),
                      SizedBox(height: 24),
                      _sidebarSection("Legal & Admin", [
                        _sidebarItem(FontAwesomeIcons.gavel, "Offense Cases"),
                        _sidebarItem(FontAwesomeIcons.fileContract, "Parivesh NoC Tracker"),
                        _sidebarItem(FontAwesomeIcons.users, "Prahari Roster"),
                         // Special link
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: InkWell(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              child: Row(children: [Icon(FontAwesomeIcons.book, size: 16, color: Colors.green.shade400), SizedBox(width: 12), Text("System Specs (DPR)", style: TextStyle(color: Colors.green.shade400, fontSize: 12, fontWeight: FontWeight.normal))]),
                            ),
                          ),
                        )
                      ]),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: Container(
                    color: Color(0xFFF1F5F9),
                    child: ListView(
                      padding: EdgeInsets.all(24),
                      children: [
                        // KPI Cards
                        Row(
                          children: [
                            _kpiCard("Today's Alerts", "24", FontAwesomeIcons.bell, Colors.red),
                            SizedBox(width: 16),
                            _kpiCard("IoT Triggers", "03", FontAwesomeIcons.towerBroadcast, Colors.orange, sub: "Vibration Detected"),
                            SizedBox(width: 16),
                            _kpiCard("NoC Pending", "12", FontAwesomeIcons.fileSignature, Colors.blue),
                            SizedBox(width: 16),
                            _kpiCard("Active AI Models", "Online", FontAwesomeIcons.brain, Colors.cyan),
                          ],
                        ),
                        SizedBox(height: 24),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 2, child: _mapWidget()),
                            SizedBox(width: 24),
                            Expanded(child: _feedWidget(state)),
                          ],
                        ),

                        SizedBox(height: 24),
                        _tableWidget(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sidebarSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(), style: TextStyle(color: Colors.grey.shade600, fontSize: 10, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        ...items
      ],
    );
  }

  Widget _sidebarItem(IconData icon, String title, {bool active = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      decoration: active ? BoxDecoration(color: Colors.green.withOpacity(0.2), border: Border(left: BorderSide(color: Colors.green, width: 2)), borderRadius: BorderRadius.horizontal(right: Radius.circular(4))) : null,
      child: ListTile(
        visualDensity: VisualDensity.compact,
        leading: Icon(icon, size: 16, color: active ? Colors.white : Colors.grey.shade400),
        title: Text(title, style: TextStyle(color: active ? Colors.white : Colors.grey.shade400, fontSize: 12)),
        onTap: () {},
      ),
    );
  }

  Widget _kpiCard(String title, String val, IconData icon, MaterialColor color, {String? sub}) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade400)),
              SizedBox(height: 4),
              Text(val, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.blueGrey.shade900)),
              if (sub != null) Text(sub, style: TextStyle(fontSize: 9, color: color))
            ]),
            Container(width: 40, height: 40, decoration: BoxDecoration(color: color.shade50, borderRadius: BorderRadius.circular(20)), child: Icon(icon, color: color.shade500, size: 16))
          ],
        ),
      ),
    );
  }

  Widget _mapWidget() {
    return Container(
      height: 400,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text("Ranthambore Live Jurisdiction", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              Row(children: [
                _badge("● High Risk", Colors.red),
                SizedBox(width: 8),
                _badge("● Patrol Active", Colors.green),
              ])
            ]),
          ),
          Expanded(
            child: Container(
              color: Colors.blueGrey.shade100,
              child: Stack(
                children: [
                  Image.network("https://upload.wikimedia.org/wikipedia/commons/e/ec/Ranthambore_National_Park_Map.jpg", fit: BoxFit.cover, width: double.infinity, height: double.infinity),
                  Positioned(
                    top: 100, left: 80,
                    child: Container(width: 16, height: 16, decoration: BoxDecoration(color: Colors.red.withOpacity(0.8), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2))).animate(onPlay: (c)=>c.repeat()).scale(begin: Offset(1,1), end: Offset(2,2), duration: 2.seconds).fadeOut(),
                  ),
                   Positioned(
                    top: 100, left: 80,
                    child: Tooltip(message: "Sensor #442", child: Container(width: 16, height: 16, decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)))),
                  ),
                   Positioned(
                    bottom: 120, right: 100,
                    child: Tooltip(message: "Ofc. Vikram", child: Container(width: 12, height: 12, decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)))),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _feedWidget(AppState state) {
    return Container(
      height: 400,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text("Live Incident Feed (10T Grid)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          Divider(height: 1),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(12),
              children: [
                ...state.dfoIncidents.map((i) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       SizedBox(width: 50, child: Text(i['time'], style: TextStyle(fontSize: 10, color: Colors.grey))),
                       Expanded(
                         child: Container(
                           padding: EdgeInsets.only(left: 8),
                           decoration: BoxDecoration(border: Border(left: BorderSide(color: i['type'] == 'alert' ? Colors.red : (i['type'] == 'warn' ? Colors.orange : Colors.blue), width: 2))),
                           child: Text(i['msg'], style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                         ),
                       )
                    ],
                  ),
                )),
                SizedBox(height: 20),
                Center(child: Text("Syncing 10T SQL Grid...", style: TextStyle(fontSize: 10, color: Colors.grey)))
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _tableWidget() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text("NoC Application Status (Parivesh Integration)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
           SizedBox(height: 16),
           Table(
             columnWidths: {0: FlexColumnWidth(2), 5: FixedColumnWidth(60)},
             children: [
               TableRow(
                 decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade100))),
                 children: ["App ID", "Applicant", "Type", "Submission", "Circle Status", "Action"].map((e) => Padding(padding: EdgeInsets.only(bottom: 8), child: Text(e.toUpperCase(), style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)))).toList()
               ),
               _tableRow("NOC-RJ-2025-882", "Adani Green Energy", "Solar Park (Cat B)", "24 Oct 2025", _badge("Pending DFO Review", Colors.orange), "View"),
               _tableRow("NOC-RJ-2025-889", "PWD Rajasthan", "Road Widening (SH-12)", "20 Oct 2025", _badge("Approved", Colors.green), "View"),
             ],
           )
        ],
      ),
    );
  }

  TableRow _tableRow(String id, String app, String type, String date, Widget status, String action) {
    return TableRow(
       children: [
         Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text(id, style: TextStyle(fontFamily: "monospace", color: Colors.green.shade700, fontSize: 12))),
         Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text(app, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
         Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text(type, style: TextStyle(fontSize: 12))),
         Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text(date, style: TextStyle(fontSize: 12))),
         Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Align(alignment: Alignment.centerLeft,child: status)),
         Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text(action, style: TextStyle(color: Colors.blue, fontSize: 12))),
       ]
    );
  }

  Widget _badge(String text, MaterialColor color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: color.shade50, borderRadius: BorderRadius.circular(4)),
      child: Text(text, style: TextStyle(color: color.shade700, fontSize: 9, fontWeight: FontWeight.bold)),
    );
  }
}
