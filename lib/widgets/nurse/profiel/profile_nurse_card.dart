import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/api/response/app/ts_people_response.dart';
import 'package:tusalud/providers/app/profile_provider.dart';
import 'package:tusalud/style/app_style.dart';

import '../../../generated/l10.dart';

class ProfileNurseCard extends StatelessWidget {
  const ProfileNurseCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context);

    if (provider.isLoading && provider.currentUser == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (provider.errorMessage != null) {
      return Center(
        child: Column(
          children: [
            Icon(Icons.error, color: Colors.red),
            Text(provider.errorMessage!),
            TextButton(
              onPressed: provider.retryLoading,
              child: Text(S.of(context).retry),
            )
          ],
        ),
      );
    }

    final user = provider.currentUser;
    if (user == null) {
      return Text(S.of(context).noUserData);
    }

    return Column(
      children: [
        const SizedBox(height: 20),
        _UserProfileCard(user: user),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppStyle.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          onPressed: () async {
            await context.pushNamed('editProfileNurse'); // ✅ Usamos GoRouter
            final provider = Provider.of<ProfileProvider>(context, listen: false);
            await provider.loadCurrentUserData();
          },
          icon: const Icon(Icons.edit, color: Colors.white),
          label: const Text(
            'Editar perfil',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),


        const SizedBox(height: 24),
        _InfoSection(
          title: S.of(context).personalInfo,
          children: [
            _InfoItem(icon: Icons.credit_card, label: S.of(context).dni, value: user.personDni ?? 'N/A'),
            _InfoItem(icon: Icons.cake, label: S.of(context).bornDate, value: _formatDate(user.personBirthdate)),
            _InfoItem(icon: Icons.timeline, label: S.of(context).age, value: user.personAge?.toString() ?? 'N/A'),
            _InfoItem(icon: Icons.transgender, label: S.of(context).gender, value: user.gender?.genderName ?? 'N/A'),
          ],
        ),
        const SizedBox(height: 16),

      ],
    );
  }

String _formatDate(String? date) {
  if (date == null || date.isEmpty) return 'N/A';
  try {
    final parsedDate = DateTime.parse(date);
    return '${parsedDate.day.toString().padLeft(2, '0')}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.year}';
  } catch (e) {
    return date;
  }
}

}



class _UserProfileCard extends StatelessWidget {
  final TsPeopleResponse user;

  const _UserProfileCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: AppStyle.primary.withOpacity(0.8),
              child: const Icon(Icons.person, color: Colors.white, size: 50),
            ),
            const SizedBox(height: 20),
            Text(
              '${user.personName ?? ''} ${user.personFahterSurname ?? ''}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppStyle.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                user.role?.roleName ?? 'N/A',
                style: TextStyle(
                  fontSize: 14,
                  color: AppStyle.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _InfoSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppStyle.primary,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppStyle.primary.withOpacity(0.1),
            child: Icon(icon, size: 20, color: AppStyle.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
