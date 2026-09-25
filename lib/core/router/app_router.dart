import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/home_page.dart';
import '../../features/profile/profile_page.dart';
import '../../features/progress/progress_page.dart';
import '../../features/training/training_page.dart';
import '../../features/workouts/workouts_page.dart';
import '../constants/app_constants.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppConstants.initialRoute,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return Scaffold(
          body: navigationShell,
          bottomNavigationBar: NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: navigationShell.goBranch,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Inicio',
              ),
              NavigationDestination(
                icon: Icon(Icons.fitness_center_outlined),
                selectedIcon: Icon(Icons.fitness_center),
                label: 'Rutinas',
              ),
              NavigationDestination(
                icon: Icon(Icons.play_circle_outline),
                selectedIcon: Icon(Icons.play_circle),
                label: 'Entrenar',
              ),
              NavigationDestination(
                icon: Icon(Icons.insights_outlined),
                selectedIcon: Icon(Icons.insights),
                label: 'Progreso',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Perfil',
              ),
            ],
          ),
        );
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) {
                return const HomePage();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/workouts',
              builder: (context, state) {
                return const WorkoutsPage();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/training',
              builder: (context, state) {
                return const TrainingPage();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/progress',
              builder: (context, state) {
                return const ProgressPage();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) {
                return const ProfilePage();
              },
            ),
          ],
        ),
      ],
    ),
  ],
);