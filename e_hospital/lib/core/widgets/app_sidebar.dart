import 'package:flutter/material.dart';
import 'package:e_hospital/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NavItem {
  final String title;
  final IconData icon;
  final String path;
  final List<NavItem>? children;
  
  const NavItem({
    required this.title,
    required this.icon,
    required this.path,
    this.children,
  });
}

class AppSidebar extends StatefulWidget {
  final String currentPath;
  final String userRole;
  final String? userName;
  final String? userEmail;
  final String? userPhotoUrl;
  
  const AppSidebar({
    Key? key,
    required this.currentPath,
    required this.userRole,
    this.userName,
    this.userEmail,
    this.userPhotoUrl,
  }) : super(key: key);
  
  @override
  State<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends State<AppSidebar> {
  bool _isExpanded = true;
  
  List<NavItem> get _adminNavItems => [
    const NavItem(
      title: 'Dashboard',
      icon: Icons.dashboard_outlined,
      path: '/admin',
    ),
    const NavItem(
      title: 'Doctors',
      icon: Icons.medical_services_outlined,
      path: '/admin/doctors',
    ),
    const NavItem(
      title: 'Patients',
      icon: Icons.people_outline,
      path: '/admin/patients',
    ),
    const NavItem(
      title: 'Appointments',
      icon: Icons.calendar_today_outlined,
      path: '/admin/appointments',
    ),
  ];
  
  List<NavItem> get _medicNavItems => [
    const NavItem(
      title: 'Dashboard',
      icon: Icons.dashboard_outlined,
      path: '/medic',
    ),
    const NavItem(
      title: 'My Patients',
      icon: Icons.people_outline,
      path: '/medic/patients',
    ),
    const NavItem(
      title: 'Appointments',
      icon: Icons.calendar_today_outlined,
      path: '/medic/appointments',
    ),
    const NavItem(
      title: 'Medical Records',
      icon: Icons.folder_outlined,
      path: '/medic/records',
    ),
    const NavItem(
      title: 'Prescriptions',
      icon: Icons.medication_outlined,
      path: '/medic/prescriptions',
    ),
    const NavItem(
      title: 'Lab Results',
      icon: Icons.biotech_outlined,
      path: '/medic/lab-results',
    ),
    const NavItem(
      title: 'Profile',
      icon: Icons.person_outline,
      path: '/medic/profile',
    ),
  ];
  
  List<NavItem> get _patientNavItems => [
    const NavItem(
      title: 'Dashboard',
      icon: Icons.dashboard_outlined,
      path: '/patient',
    ),
    const NavItem(
      title: 'Appointments',
      icon: Icons.calendar_today_outlined,
      path: '/patient/appointments',
    ),
    const NavItem(
      title: 'My Doctors',
      icon: Icons.medical_services_outlined,
      path: '/patient/doctors',
    ),
    const NavItem(
      title: 'Medical Records',
      icon: Icons.folder_outlined,
      path: '/patient/records',
    ),
    const NavItem(
      title: 'Prescriptions',
      icon: Icons.medication_outlined,
      path: '/patient/prescriptions',
    ),
    const NavItem(
      title: 'Lab Results',
      icon: Icons.biotech_outlined,
      path: '/patient/lab-results',
    ),
    const NavItem(
      title: 'Profile',
      icon: Icons.person_outline,
      path: '/patient/profile',
    ),
  ];
  
  List<NavItem> get _navItems {
    switch (widget.userRole) {
      case 'hospitalAdmin':
        return _adminNavItems;
      case 'medicalPersonnel':
        return _medicNavItems;
      case 'patient':
      default:
        return _patientNavItems;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: _isExpanded ? 260 : 80,
      color: AppColors.surfaceDark,
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              children: [
                for (final item in _navItems) _buildNavItem(item),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.dark),
          _buildFooter(),
        ],
      ),
    );
  }
  
  Widget _buildHeader() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: AppColors.darker,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.local_hospital_rounded,
            color: AppColors.primary,
            size: 28,
          ),
          if (_isExpanded) ...[
            const SizedBox(width: 16),
            const Text(
              'E-Hospital',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildNavItem(NavItem item) {
    final isActive = widget.currentPath.startsWith(item.path);
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isActive ? AppColors.primary.withOpacity(0.2) : Colors.transparent,
      ),
      child: ListTile(
        leading: Icon(
          item.icon,
          color: isActive ? AppColors.primary : Colors.white70,
        ),
        title: _isExpanded
            ? Text(
                item.title,
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.white70,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        dense: true,
        visualDensity: VisualDensity.compact,
        onTap: () {
          if (context.mounted) {
            Navigator.pushNamed(context, item.path);
          }
        },
      ),
    );
  }
  
  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          if (_isExpanded) ...[
            ListTile(
              leading: widget.userPhotoUrl != null
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(widget.userPhotoUrl!),
                      radius: 16,
                    )
                  : const CircleAvatar(
                      backgroundColor: AppColors.primary,
                      radius: 16,
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
              title: Text(
                widget.userName ?? 'User',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                widget.userEmail ?? '',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
            const SizedBox(height: 8),
          ],
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.white70,
            ),
            title: _isExpanded
                ? const Text(
                    'Log Out',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  )
                : null,
            contentPadding: EdgeInsets.zero,
            dense: true,
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              }
            },
          ),
        ],
      ),
    );
  }
} 