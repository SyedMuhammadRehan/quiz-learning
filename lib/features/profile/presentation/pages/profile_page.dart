import 'package:flutter/material.dart';
import '../../../../core/utils/responsive.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: Responsive.getPagePadding(context),
            child: Column(
              children: [
                // Profile Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      // Profile Image
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          image: const DecorationImage(
                            image: NetworkImage('https://picsum.photos/150/150?random=2'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Name and Level
                      const Text(
                        'John Doe',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Level 5 Quiz Master',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Stats Cards Row 1
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Total Quizzes',
                        '25',
                        Icons.quiz,
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        'Best Score',
                        '10/10',
                        Icons.star,
                        Colors.amber,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Stats Cards Row 2
                Row(
                  children: [
                    Expanded(
                    child: _buildStatCard(
                      'Avg Accuracy',
                      '85%',
                      Icons.adjust,
                      Colors.green,
                    ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        'Time Record',
                        '8:23',
                        Icons.timer,
                        Colors.purple,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Achievements Section
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Achievements',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    _buildAchievementCard(
                      'First Quiz',
                      Icons.emoji_events,
                      Colors.amber,
                      unlocked: true,
                    ),
                    _buildAchievementCard(
                      'Perfect Score',
                      Icons.star,
                      Colors.green,
                      unlocked: true,
                    ),
                    _buildAchievementCard(
                      'Speed Demon',
                      Icons.flash_on,
                      Colors.red,
                      unlocked: true,
                    ),
                    _buildAchievementCard(
                      'Knowledge Master',
                      Icons.school,
                      Colors.blue,
                      unlocked: false,
                    ),
                    _buildAchievementCard(
                      'Consistency King',
                      Icons.calendar_today,
                      Colors.purple,
                      unlocked: false,
                    ),
                    _buildAchievementCard(
                      'Legend',
                      Icons.diamond,
                      Colors.pink,
                      unlocked: false,
                    ),
                  ],
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(String title, IconData icon, Color color,
      {required bool unlocked}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: unlocked ? Colors.white : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        boxShadow: unlocked
            ? [
                BoxShadow(
                  color: color.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: unlocked ? color : Colors.grey,
            size: 24,
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: unlocked ? Colors.black : Colors.grey,
              fontWeight: unlocked ? FontWeight.w600 : FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
