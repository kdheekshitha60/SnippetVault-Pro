import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SnippetVaultApp());
}

class SnippetVaultApp extends StatelessWidget {
  const SnippetVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SnippetVault Pro',
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD946EF), // Cyber Fuchsia Accent
          brightness: Brightness.dark,
          surface: const Color(0xFF111827),
        ),
        scaffoldBackgroundColor: const Color(0xFF030712), // Deep Space Black
      ),
      home: const MainAppFlowController(),
    );
  }
}

// 🎛️ CENTRAL ROUTING & WORKFLOW LIFECYCLE MANAGEMENT LAYER
class MainAppFlowController extends StatefulWidget {
  const MainAppFlowController({super.key});

  @override
  State<MainAppFlowController> createState() => _MainAppFlowControllerState();
}

class _MainAppFlowControllerState extends State<MainAppFlowController> {
  String _currentScreenState = 'SPLASH'; // SPLASH -> LOGIN -> CINEMATIC_WELCOME -> DASHBOARD
  String _sessionUserIdentity = "K. Dheekshitha"; 

  void _transitionTo(String nextState) {
    setState(() {
      _currentScreenState = nextState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🌊 VIBRANT COLORFUL MOVING INDIGO GRADIENT BACKGROUND LAYER
          const Positioned.fill(child: PremiumVibrantMeshBackground()),
          
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 700),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            child: _buildActiveFlowWidget(),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFlowWidget() {
    switch (_currentScreenState) {
      case 'SPLASH':
        return StartupBrandingSplash(
          key: const ValueKey('Splash'),
          onComplete: () => _transitionTo('LOGIN'),
        );
      case 'LOGIN':
        return CleanFuturisticLogin(
          key: const ValueKey('Login'),
          onLoginSuccess: (verifiedUsername) {
            setState(() {
              _sessionUserIdentity = verifiedUsername;
            });
            _transitionTo('CINEMATIC_WELCOME');
          },
        );
      case 'CINEMATIC_WELCOME':
        return CinematicPascotWelcome(
          key: const ValueKey('CinematicWelcome'),
          onOnboardingComplete: () => _transitionTo('DASHBOARD'),
        );
      case 'DASHBOARD':
        return WorkspaceDashboard(
          key: const ValueKey('Dashboard'),
          initialAuthName: _sessionUserIdentity,
          onLogout: () {
            _transitionTo('LOGIN');
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

// 🌊 FLUID GLOWING CYBER-GRADIENT CANVAS ENGINE
class PremiumVibrantMeshBackground extends StatefulWidget {
  const PremiumVibrantMeshBackground({super.key});

  @override
  State<PremiumVibrantMeshBackground> createState() => _PremiumVibrantMeshBackgroundState();
}

class _PremiumVibrantMeshBackgroundState extends State<PremiumVibrantMeshBackground> with SingleTickerProviderStateMixin {
  late AnimationController _meshController;
  late Animation<double> _meshAnimation;

  @override
  void initState() {
    super.initState();
    _meshController = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat(reverse: true);
    _meshAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _meshController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _meshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _meshAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF030712),
                Color.lerp(const Color(0xFF3B0764), const Color(0xFF1E3A8A), _meshAnimation.value)!, 
                Color.lerp(const Color(0xFF030712), const Color(0xFF9D174D), _meshAnimation.value)!, 
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        );
      },
    );
  }
}

// 🏁 INITIAL STARTUP BRANDING SPLASH
class StartupBrandingSplash extends StatefulWidget {
  final VoidCallback onComplete;
  const StartupBrandingSplash({super.key, required this.onComplete});

  @override
  State<StartupBrandingSplash> createState() => _StartupBrandingSplashState();
}

class _StartupBrandingSplashState extends State<StartupBrandingSplash> with SingleTickerProviderStateMixin {
  late AnimationController _opacityController;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _opacityController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(_opacityController);
    _opacityController.forward();
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) widget.onComplete();
    });
  }

  @override
  void dispose() {
    _opacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeTransition(
        opacity: _fade,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("🔮", style: TextStyle(fontSize: 64)),
            SizedBox(height: 24),
            Text("SnippetVault Pro", style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -1.5)),
            SizedBox(height: 6),
            Text("Next-Gen Intelligent Media Ledger Matrix", style: TextStyle(color: Colors.grey, fontSize: 13, letterSpacing: 0.5)),
          ],
        ),
      ),
    );
  }
}

// 🔐 SECURITY AUTHENTICATION CONSOLE GATEWAY
class CleanFuturisticLogin extends StatefulWidget {
  final Function(String) onLoginSuccess;
  const CleanFuturisticLogin({super.key, required this.onLoginSuccess});

  @override
  State<CleanFuturisticLogin> createState() => _CleanFuturisticLoginState();
}

class _CleanFuturisticLoginState extends State<CleanFuturisticLogin> {
  bool _hidePasswordState = true;
  bool _acceptDirectives = false;
  final _userIdController = TextEditingController();
  final _userKeyController = TextEditingController();
  final _formGlobalKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _userIdController.dispose();
    _userKeyController.dispose();
    super.dispose();
  }

  void _verifyLoginSession() {
    if (_formGlobalKey.currentState!.validate()) {
      if (!_acceptDirectives) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color(0xFFEF4444),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            content: const Text("⚠️ Authorization Denied: You must verify and accept privacy directives rules."),
          ),
        );
        return;
      }
      widget.onLoginSuccess(_userIdController.text.trim()); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Form(
          key: _formGlobalKey,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A).withOpacity(0.65),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: const Color(0xFFD946EF).withOpacity(0.2)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text("Console Auth", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white)),
                const SizedBox(height: 6),
                const Text("Initialize credentials to unlock master console panel layers.", style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.4)),
                const SizedBox(height: 36),
                TextFormField(
                  controller: _userIdController,
                  decoration: InputDecoration(
                    labelText: "Email or System Username",
                    prefixIcon: const Icon(Icons.shield_outlined, size: 20),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  validator: (val) => (val == null || val.isEmpty) ? "Identity signature vector mandatory" : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _userKeyController,
                  obscureText: _hidePasswordState,
                  decoration: InputDecoration(
                    labelText: "Master Vault Crypt Password",
                    prefixIcon: const Icon(Icons.key_rounded, size: 20),
                    suffixIcon: IconButton(
                      icon: Icon(_hidePasswordState ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20, color: Colors.grey),
                      onPressed: () => setState(() => _hidePasswordState = !_hidePasswordState),
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                validator: (val) => (val == null || val.length < 4) ? "Encryption validation token required" : null,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Checkbox(
                    value: _acceptDirectives,
                    activeColor: const Color(0xFFD946EF),
                    onChanged: (value) => setState(() => _acceptDirectives = value!),
                  ),
                  const Expanded(
                    child: Text(
                      "I verify and accept terms of system cryptography handling policies.",
                      style: TextStyle(fontSize: 11, color: Colors.grey, height: 1.4),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD946EF),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(54),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: _verifyLoginSession,
                child: const Text("Authenticate Matrix Console", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              )
            ],
          ),
        ),
      ),
    ),
  );
}
}


class CinematicPascotWelcome extends StatefulWidget {
  final VoidCallback onOnboardingComplete;
  const CinematicPascotWelcome({super.key, required this.onOnboardingComplete});

  @override
  State<CinematicPascotWelcome> createState() => _CinematicPascotWelcomeState();
}

class _CinematicPascotWelcomeState extends State<CinematicPascotWelcome> with TickerProviderStateMixin {
  late AnimationController _flightController;
  late Animation<Offset> _flightOffset;
  late AnimationController _boxController;
  late Animation<double> _boxOpenScale;
  bool _isCoverOpen = false;

  @override
  void initState() {
    super.initState();
    _flightController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _flightOffset = Tween<Offset>(begin: const Offset(2.0, -2.0), end: Offset.zero).animate(
      CurvedAnimation(parent: _flightController, curve: Curves.easeOutBack),
    );
    _boxController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _boxOpenScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _boxController, curve: Curves.elasticOut),
    );

    _flightController.forward().then((_) {
      if (mounted) {
        setState(() => _isCoverOpen = true);
        _boxController.forward();
      }
    });

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        _boxController.reverse().then((_) {
          _flightController.reverse().then((_) => widget.onOnboardingComplete());
        });
      }
    });
  }

  @override
  void dispose() {
    _flightController.dispose();
    _boxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SlideTransition(
            position: _flightOffset,
            child: Container(
              width: 130,
              height: 130,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [Color(0xFFEC4899), Color(0xFF8B5CF6)]),
              ),
              alignment: Alignment.center,
              child: const CircleAvatar(
                radius: 60,
                backgroundColor: Color(0xFF1E1B4B),
                child: Text("🐼", style: TextStyle(fontSize: 60)),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ScaleTransition(
            scale: _boxOpenScale,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1F1D36).withOpacity(0.95),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFD946EF), width: 2),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(_isCoverOpen ? Icons.lock_open_rounded : Icons.lock_outline, color: const Color(0xFFF472B6)),
                      const SizedBox(width: 10),
                      const Text("Hi! Welcome 👋", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text("System Core Decrypted. Initializing Multimedia Workspace...", textAlign: TextAlign.center, style: TextStyle(color: Color(0xFFE2E8F0), fontSize: 13)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class WorkspaceDashboard extends StatefulWidget {
  final VoidCallback onLogout;
  final String initialAuthName;
  const WorkspaceDashboard({super.key, required this.onLogout, required this.initialAuthName});

  @override
  State<WorkspaceDashboard> createState() => _WorkspaceDashboardState();
}

class _WorkspaceDashboardState extends State<WorkspaceDashboard> {
  String _activeTabRoute = 'Links';
  bool _sidebarExpanded = true;
  bool _isPremiumTier = false;
  late String _profileName;
  String _profileUser = "sys_admin@snippetvault.internal";
  String _profileImage = "https://dicebear.com";
  int _selectedMascotIndex = 0; // Tracks user's profile avatar selection
  final List<String> _mascotList = ["🐼", "🦊", "🐱", "🤖", "🚀", "👑"];

  
  List<String> _cachedLinks = [];
  List<String> _cachedVaultItems = [];
  List<String> _cachedFiles = [];
  
  final _inputLabel = TextEditingController();
  final _inputContent = TextEditingController();

  final _profileNameController = TextEditingController();
  final _profileUserController = TextEditingController();
  final _profileImgController = TextEditingController();
  bool _maskSecretKeysData = true;

  @override
  void initState() {
    super.initState();
    _profileName = widget.initialAuthName; // Synchronizing login input live!
    _profileNameController.text = _profileName;
    _profileUserController.text = _profileUser;
    _profileImgController.text = _profileImage;
    _syncSystemCacheData();
  }

  @override
  void dispose() {
    _inputLabel.dispose();
    _inputContent.dispose();
    _profileNameController.dispose();
    _profileUserController.dispose();
    _profileImgController.dispose();
    super.dispose();
  }

  void _syncSystemCacheData() async {
    final cache = await SharedPreferences.getInstance();
    setState(() {
      _cachedLinks = cache.getStringList('vault_links_set') ?? [];
      _cachedVaultItems = cache.getStringList('vault_secrets_set') ?? [];
      _cachedFiles = cache.getStringList('vault_files_set') ?? [];
      _profileName = cache.getString('p_name') ?? widget.initialAuthName;
      _profileUser = cache.getString('p_user') ?? "sys_admin@snippetvault.internal";
      _profileImage = cache.getString('p_img') ?? "https://dicebear.com";
      _profileNameController.text = _profileName;
      _profileUserController.text = _profileUser;
      _profileImgController.text = _profileImage;
    });
  }

  void _persistActiveData(String targetingKey, List<String> targetList) async {
    final cache = await SharedPreferences.getInstance();
    await cache.setStringList(targetingKey, targetList);
  }

  Widget _buildMascotCompanionAvatarWidget(String activeRoute) {
    IconData companionIcon;
    Color bubbleThemeColor;
    switch (activeRoute) {
      case 'Links':
        companionIcon = Icons.biotech_rounded;
        bubbleThemeColor = const Color(0xFFD946EF);
        break;
      case 'Vault':
        companionIcon = Icons.gpp_good_rounded;
        bubbleThemeColor = const Color(0xFFF59E0B);
        break;
      case 'Files':
        companionIcon = Icons.analytics_rounded;
        bubbleThemeColor = const Color(0xFF3B82F6);
        break;
      default:
        companionIcon = Icons.account_circle_rounded;
        bubbleThemeColor = Colors.grey;
    }
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        color: bubbleThemeColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: bubbleThemeColor.withOpacity(0.4), width: 1.5),
      ),
      child: Icon(companionIcon, color: bubbleThemeColor, size: 28),
    );
  }

  String _getTabMascotCharacterMessage(String activeRoute) {
    switch (activeRoute) {
      case 'Links':
        return "System Operator ready. Let's analyze your web brand registers! 🌐⚡";
      case 'Vault':
        return "Locker protocols online. Your security keys are safe under my watch! 🔐🛡️";
      case 'Files':
        return "Data cloud vectors loaded cleanly. Ready to index files database grid! 📂💾";
      default:
        return "Profile configurations panel console matrix live! 👤💖";
    }
  }
  void _renderPremiumPaywallSheet() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1B4B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: const BorderSide(color: Color(0xFFD946EF), width: 1.5)),
        title: const Row(
          children: [
            Text("👑 "),
            Text("Upgrade to Premium Tier", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("You have reached the maximum 4 free slots limit of the standard ledger track.", style: TextStyle(color: Colors.white, fontSize: 13)),
            SizedBox(height: 12),
            Text("Unlock Premium to gain:\n• Unlimited asset ledger record slots\n• Advanced cryptography configurations\n• Custom holographic companion models", style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel Console", style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD946EF), foregroundColor: Colors.white),
            onPressed: () {
              setState(() => _isPremiumTier = true);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Account upgraded to Premium successfully! 👑💖")));
            },
            child: const Text("Unlock Access (\$4.99/mo)", style: TextStyle(fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  void _executeAssetCreation(String pipelineContext) {
    if (_inputLabel.text.isEmpty || _inputContent.text.isEmpty) return;
    if (!_isPremiumTier) {
      if (pipelineContext == 'Links' && _cachedLinks.length >= 4) { _renderPremiumPaywallSheet(); return; }
      if (pipelineContext == 'Vault' && _cachedVaultItems.length >= 4) { _renderPremiumPaywallSheet(); return; }
      if (pipelineContext == 'Files' && _cachedFiles.length >= 4) { _renderPremiumPaywallSheet(); return; }
    }
    setState(() {
      String compiledDataToken = "${_inputLabel.text}:::${_inputContent.text}";
      if (pipelineContext == 'Links') {
        _cachedLinks.add(compiledDataToken);
        _persistActiveData('vault_links_set', _cachedLinks);
      } else if (pipelineContext == 'Vault') {
        _cachedVaultItems.add(compiledDataToken);
        _persistActiveData('vault_secrets_set', _cachedVaultItems);
      } else if (pipelineContext == 'Files') {
        _cachedFiles.add(compiledDataToken);
        _persistActiveData('vault_files_set', _cachedFiles);
      }
    });
    _inputLabel.clear();
    _inputContent.clear();
    Navigator.pop(context);
  }

  void _wipeAssetRecord(String targetRoute, int targetingIndex) {
    setState(() {
      if (targetRoute == 'Links') {
        _cachedLinks.removeAt(targetingIndex);
        _persistActiveData('vault_links_set', _cachedLinks);
      } else if (targetRoute == 'Vault') {
        _cachedVaultItems.removeAt(targetingIndex);
        _persistActiveData('vault_secrets_set', _cachedVaultItems);
      } else if (targetRoute == 'Files') {
        _cachedFiles.removeAt(targetingIndex);
        _persistActiveData('vault_files_set', _cachedFiles);
      }
    });
  }

  void _updateProfileData(String name, String user, String imageLink) async {
    final cache = await SharedPreferences.getInstance();
    setState(() {
      _profileName = name;
      _profileUser = user;
      _profileImage = imageLink;
    });
    await cache.setString('p_name', name);
    await cache.setString('p_user', user);
    await cache.setString('p_img', imageLink);
  }

  Widget _renderSidebarMenuRouteTile(IconData tileIcon, String tileLabel, String routeString, {Color? color}) {
    bool selected = _activeTabRoute == routeString;
    return InkWell(
      onTap: () {
        if (routeString == 'Logout') {
          widget.onLogout();
        } else {
          setState(() => _activeTabRoute = routeString);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFD946EF).withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(tileIcon, size: 20, color: color ?? (selected ? const Color(0xFFF472B6) : Colors.grey)),
            if (_sidebarExpanded) ...[
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  tileLabel,
                  style: TextStyle(
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                    color: color ?? (selected ? Colors.white : Colors.grey),
                    fontSize: 13,
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _resolveActiveModuleWorkspacePanel() {
    if (_activeTabRoute == 'Links') return _buildLinksViewPanelLayout();
    if (_activeTabRoute == 'Vault') return _buildSecureVaultViewPanelLayout();
    if (_activeTabRoute == 'Files') return _buildFilesViewPanelLayout();
    return _buildProfileEditingHubView();
  }

  Widget _buildLinksViewPanelLayout() {
    if (_cachedLinks.isEmpty) return const Center(child: Text("Deck slot list register empty. Tap Add below!", style: TextStyle(color: Colors.grey)));
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: _cachedLinks.length,
      itemBuilder: (context, index) {
        var blocks = _cachedLinks[index].split(":::");
        String captionTitle = blocks.isNotEmpty ? blocks[0] : "Untitled Link";
        String addressValue = blocks.length > 1 ? blocks[1] : "";
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          color: const Color(0xFF1E293B).withOpacity(0.4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: Colors.white10)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: const ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: CircleAvatar(
                backgroundColor: Color(0xFF475569),
                child: Icon(Icons.link_rounded, color: Colors.white, size: 18),
              ),
            ),
            title: Text(captionTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
            subtitle: Text(addressValue, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.grey, fontSize: 13)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.copy, size: 18, color: Colors.grey),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: addressValue));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Link path register copied! 📋")));
                  },
                ),
                IconButton(icon: const Icon(Icons.delete_outline, size: 18, color: Colors.redAccent), onPressed: () => _wipeAssetRecord('Links', index)),
              ],
            ),
          ),
        );
      },
    );
  }
  Widget _buildSecureVaultViewPanelLayout() {
    if (_cachedVaultItems.isEmpty) return const Center(child: Text("Credentials storage keys empty. Tap Add below!", style: TextStyle(color: Colors.grey)));
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: _cachedVaultItems.length,
      itemBuilder: (context, index) {
        var blocks = _cachedVaultItems[index].split(":::");
        String vaultTitle = blocks.isNotEmpty ? blocks[0] : "Secret Slot";
        String vaultSecret = blocks.length > 1 ? blocks[1] : "";
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          color: const Color(0xFF0F172A).withOpacity(0.4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: Colors.white10)),
          child: ListTile(
            leading: const CircleAvatar(backgroundColor: Color(0x1FBBF246), child: Icon(Icons.key_rounded, color: Colors.amber, size: 18)),
            title: Text(vaultTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: Text(_maskSecretKeysData ? "••••••••••••••••" : vaultSecret, style: const TextStyle(fontFamily: 'monospace', color: Colors.grey, fontSize: 13)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(_maskSecretKeysData ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 18, color: Colors.grey),
                  onPressed: () => setState(() => _maskSecretKeysData = !_maskSecretKeysData),
                ),
                IconButton(icon: const Icon(Icons.delete_outline, size: 18, color: Colors.redAccent), onPressed: () => _wipeAssetRecord('Vault', index)),
              ],
            ),
          ),
        );
      },
    );
  }

    Widget _buildFilesViewPanelLayout() {
    if (_cachedFiles.isEmpty) return const Center(child: Text("Files database structure registry empty. Tap Add below!", style: TextStyle(color: Colors.grey)));
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 14, crossAxisSpacing: 14, childAspectRatio: 1.4),
      itemCount: _cachedFiles.length,
      itemBuilder: (context, index) {
        var blocks = _cachedFiles[index].split(":::");
        String fileTitle = blocks.isNotEmpty ? blocks[0] : "Unnamed Asset File";
        String filePath = blocks.length > 1 ? blocks[1] : "";
        
        return InkWell(
          borderRadius: BorderRadius.circular(14),
          // 📋 INSTANT CLICK-TO-COPY TRIGGER: Copies the file path directly to the user's system!
          onTap: () {
            Clipboard.setData(ClipboardData(text: filePath));
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: const Color(0xFF1E1B4B),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFF818CF8))),
                content: Text("📋 File path copied: $fileTitle. Paste into your explorer console!"),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B).withOpacity(0.4), 
              borderRadius: BorderRadius.circular(14), 
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.insert_drive_file_outlined, color: Color(0xFF818CF8), size: 20),
                const Spacer(),
                Text(fileTitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 2),
                Text(filePath, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                Align(
                  alignment: Alignment.bottomRight, 
                  child: IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, size: 16, color: Colors.redAccent), 
                    onPressed: () => _wipeAssetRecord('Files', index),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

      Widget _buildProfileEditingHubView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B).withOpacity(0.5), 
            borderRadius: BorderRadius.circular(20), 
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🔄 INTERACTIVE AVATAR SELECTION DECK
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_rounded, color: Color(0xFFD946EF)),
                    onPressed: () {
                      setState(() {
                        _selectedMascotIndex = (_selectedMascotIndex - 1 + _mascotList.length) % _mascotList.length;
                      });
                    },
                  ),
                  Container(
                    width: 95,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFEC4899), Color(0xFF8B5CF6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [BoxShadow(color: const Color(0xFFD946EF).withOpacity(0.4), blurRadius: 15)],
                    ),
                    alignment: Alignment.center,
                    child: Text(_mascotList[_selectedMascotIndex], style: const TextStyle(fontSize: 46)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFFD946EF)),
                    onPressed: () {
                      setState(() {
                        _selectedMascotIndex = (_selectedMascotIndex + 1) % _mascotList.length;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text("Tap arrows to change console identity avatar", style: TextStyle(color: Colors.grey, fontSize: 11)),
              const SizedBox(height: 24),
              TextField(
                controller: _profileNameController, 
                decoration: const InputDecoration(labelText: "Display Profile Name Custom text", border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)))),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _profileUserController, 
                decoration: const InputDecoration(labelText: "Username Identifier String text", border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)))),
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD946EF), 
                  foregroundColor: Colors.white, 
                  minimumSize: const Size.fromHeight(50), 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  _updateProfileData(_profileNameController.text, _profileUserController.text, _profileImgController.text);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Profile data transformations successfully compiled! 👤💖")),
                  );
                },
                child: const Text("Commit Custom Profile Data Transformations", style: TextStyle(fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      ),
    );
  }


  void _renderAssetInsertionDialogForm(String activeContext) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Add New $activeContext Record Slot", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _inputLabel, decoration: const InputDecoration(labelText: "Friendly Item Label Name")),
            const SizedBox(height: 12),
            TextField(controller: _inputContent, decoration: InputDecoration(labelText: activeContext == 'Vault' ? "Secure Key Secret Value" : "Reference String or Destination Address URL")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD946EF)),
            onPressed: () => _executeAssetCreation(activeContext),
            child: const Text("Commit Entry"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: _sidebarExpanded ? 250 : 78,
            color: Colors.black.withOpacity(0.55),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                                               Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      // Dynamic vector avatar syncs instantly across panels
                      Container(
                        width: 38,
                        height: 36,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(colors: [Color(0xFFEC4899), Color(0xFF8B5CF6)]),
                        ),
                        alignment: Alignment.center,
                        child: Text(_mascotList[_selectedMascotIndex], style: const TextStyle(fontSize: 18)),
                      ),
                      if (_sidebarExpanded) ...[
                        const SizedBox(width: 12),
                        Expanded(child: Text(_profileName, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                      ]
                    ],
                  ),
                ),

                const SizedBox(height: 32),
                _renderSidebarMenuRouteTile(Icons.link_rounded, "Links Registry", 'Links'),
                _renderSidebarMenuRouteTile(Icons.lock_outline_rounded, "Secure Vault Locker", 'Vault'),
                _renderSidebarMenuRouteTile(Icons.folder_open_outlined, "Files System Grid", 'Files'),
                _renderSidebarMenuRouteTile(Icons.badge_outlined, "Personal Profile Hub", 'Profile'),
                const Spacer(),
                _renderSidebarMenuRouteTile(Icons.logout_rounded, "Exit Console", 'Logout', color: Colors.redAccent),
                IconButton(
                  padding: const EdgeInsets.all(16),
                  icon: Icon(_sidebarExpanded ? Icons.chevron_left_rounded : Icons.chevron_right_rounded, color: Colors.grey),
                  onPressed: () => setState(() => _sidebarExpanded = !_sidebarExpanded),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          Expanded(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                title: Text("SnippetVault Matrix // $_activeTabRoute", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Colors.white)),
                actions: [
                  if (_isPremiumTier) const Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: Chip(
                      label: Text("PREMIUM ACCOUNT ACTIVE 👑", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                      backgroundColor: Colors.amber,
                    ),
                  )
                ],
              ),
              body: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(24),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFD946EF).withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        _buildMascotCompanionAvatarWidget(_activeTabRoute),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("WORKSPACE CHARACTER COMPANION", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFD946EF))),
                              const SizedBox(height: 4),
                              Text(_getTabMascotCharacterMessage(_activeTabRoute), style: const TextStyle(fontSize: 13, color: Colors.white70, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: _resolveActiveModuleWorkspacePanel(),
                    ),
                  ),
                ],
              ),
              floatingActionButton: (_activeTabRoute == 'Links' || _activeTabRoute == 'Vault' || _activeTabRoute == 'Files')
                  ? FloatingActionButton.extended(
                      backgroundColor: const Color(0xFFD946EF),
                      foregroundColor: Colors.white,
                      icon: const Icon(Icons.add_moderator_rounded),
                      label: Text("Add $_activeTabRoute Slot Entry"),
                      onPressed: () => _renderAssetInsertionDialogForm(_activeTabRoute),
                    )
                  : null,
            ),
          )
        ],
      ),
    );
  }
}
