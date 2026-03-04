import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../Models/Server.dart';
import '../Utils/Global.dart';
import '../Utils/Theme.dart';

class ServerSelectionScreen extends StatefulWidget {
  final List<ServerModel> servers;
  ServerModel selectedServer;
  final Function(ServerModel) onSelect;

  ServerSelectionScreen({
    super.key,
    required this.servers,
    required this.selectedServer,
    required this.onSelect,
  });

  @override
  State<ServerSelectionScreen> createState() => _ServerSelectionScreenState();
}

class _ServerSelectionScreenState extends State<ServerSelectionScreen> {
  bool _isAutoSelectionEnabled = true;
  bool _isGlobalTabActive = false;
  
  // Logique de recherche
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  // Fonction pour filtrer la liste des serveurs
  List<ServerModel> get _filteredServers {
    if (_searchQuery.isEmpty) return widget.servers;
    return widget.servers
        .where((s) => s.country.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  // Déterminer la couleur selon le ping
  Color _getPingColor(int ping) {
    if (ping < 50) return Colors.redAccent;
    if (ping < 150) return Colors.orangeAccent;
    return Colors.greenAccent;
  }

  void _handleServerAction(int index, ServerModel server) {
    setState(() {
      if (server.isConnected) {
        server.isConnected = false;
         isConnectedGlobal = false;
      } else {
        for (var s in widget.servers) {
          s.isConnected = false;
        }
        server.isConnected = true;
        widget.selectedServer = server;
        selectedServerGlobal = server; 
        isConnectedGlobal = true;
       // widget.onSelect(server); 
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        setState(() {
          isConnectedGlobal = false;
        });
        return Future.value(true); 
      },
      child: Scaffold(
        backgroundColor: PRIMARYCOLOR, 
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(),
              const SizedBox(height: 20),
              _buildSearchBar(),
              const SizedBox(height: 20),
              _buildTabs(),
              const SizedBox(height: 20),
              _buildAutoSelectionToggle(),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Select server',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: _filteredServers.isEmpty 
                  ? const Center(child: Text("No server found", style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      itemCount: _filteredServers.length,
                      itemBuilder: (context, index) {
                        final server = _filteredServers[index];
                        return _buildServerItem(server, index);
                      },
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2640),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
            ),
          ),
          const Text(
            'Select server',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 32),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFF151D33),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFF1E2640), width: 1),
        ),
        child: Row(
          children: [
            const SizedBox(width: 15),
            const Icon(Icons.search, color: Colors.grey, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _searchQuery = value),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Search Country...',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  border: InputBorder.none,
                ),
              ),
            ),
            if (_searchQuery.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey, size: 18),
                onPressed: () {
                  _searchController.clear();
                  setState(() => _searchQuery = "");
                },
              ),
            const Icon(Icons.mic_none, color: Colors.grey, size: 20),
            const SizedBox(width: 15),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: const Color(0xFF151D33),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _isGlobalTabActive = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: !_isGlobalTabActive ? const Color(0xFF1E2640) : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'Recommended',
                      style: TextStyle(
                        color: !_isGlobalTabActive ? Colors.white : Colors.grey,
                        fontWeight: !_isGlobalTabActive ? FontWeight.w600 : FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _isGlobalTabActive = true),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: _isGlobalTabActive ? const Color(0xFF1E2640) : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'Global',
                      style: TextStyle(
                        color: _isGlobalTabActive ? Colors.white : Colors.grey,
                        fontWeight: _isGlobalTabActive ? FontWeight.w600 : FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAutoSelectionToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              Icon(Icons.swap_calls, color: Colors.grey, size: 20),
              SizedBox(width: 10),
              Text(
                'Auto Selection',
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => setState(() => _isAutoSelectionEnabled = !_isAutoSelectionEnabled),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              width: 44,
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: _isAutoSelectionEnabled ? const Color(0xFF1A4CFF) : const Color(0xFF2B3A6B),
              ),
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    top: 2,
                    left: _isAutoSelectionEnabled ? 22 : 2,
                    right: _isAutoSelectionEnabled ? 2 : 22,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }


  Widget _buildServerItem(ServerModel server, int index) {
    Color pingColor = _getPingColor(server.basePing);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF151D33),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: server.isConnected ? const Color(0xFF1A4CFF).withOpacity(0.5) : Colors.transparent,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFF1E2640),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(server.flagEmoji, style: const TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  server.country,
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  '${server.locationCount} Location',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Row(
            children: [
              AnimatedPingBars(color: pingColor),
              const SizedBox(width: 4),
              Text(
                '${server.basePing}ms',
                style: TextStyle(color: pingColor, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(width: 15),
          GestureDetector(
            onTap: () => _handleServerAction(index, server),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                // Changement de couleur fond : Rouge sombre si connecté, Bleu si déconnecté
                color: server.isConnected ? const Color(0xFF2A1B28) : const Color(0xFF1E2640),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: server.isConnected ? Colors.red.withOpacity(0.5) : Colors.transparent,
                ),
              ),
              child: Text(
                server.isConnected ? 'Disconnect' : 'Connect',
                style: TextStyle(
                  color: server.isConnected ? const Color(0xFFFF3B30) : Colors.blueAccent,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class AnimatedPingBars extends StatefulWidget {
  final Color color;
  const AnimatedPingBars({super.key, required this.color});

  @override
  State<AnimatedPingBars> createState() => _AnimatedPingBarsState();
}

class _AnimatedPingBarsState extends State<AnimatedPingBars> {
  late Timer _timer;
  List<double> _heights = [0.4, 0.7, 1.0];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 600), (timer) {
      if (mounted) {
        setState(() {
          _heights = [
            Random().nextDouble() * 0.5 + 0.3,
            Random().nextDouble() * 0.6 + 0.4,
            Random().nextDouble() * 0.4 + 0.6,
          ];
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(3, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          margin: const EdgeInsets.only(right: 2),
          width: 2.5,
          height: 12 * _heights[index],
          decoration: BoxDecoration(
            color: widget.color, // Utilise la couleur dynamique
            borderRadius: BorderRadius.circular(1),
          ),
        );
      }),
    );
  }
}