import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/home_page.dart';
import '../../features/onboarding/onboarding_page.dart';
import '../../features/profile/profile_page.dart';
import '../../features/progress/progress_page.dart';
import '../../features/startup/startup_page.dart';
import '../../features/training/training_page.dart';
import '../../features/workouts/suggested_routine_page.dart';
import '../../features/workouts/workouts_page.dart';
import '../widgets/app_bottom_nav.dart';
import 'active_tab_reporter.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/startup',
  routes: [
    GoRoute(
      path: '/startup',
      builder: (context, state) {
        return const StartupPage();
      },
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) {
        return const OnboardingPage();
      },
    ),
    GoRoute(
      path: '/suggested-routine',
      builder: (context, state) {
        return const SuggestedRoutinePage();
      },
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return Scaffold(
          body: ActiveTabReporter(
            navigationShell: navigationShell,
            child: navigationShell,
          ),
          bottomNavigationBar: AppBottomNav(
            currentIndex: navigationShell.currentIndex,
            onSelected: navigationShell.goBranch,
            featuredIndex: 2,
            destinations: const [
              AppNavDestination(
                icon: Icons.home_outlined,
                selectedIcon: Icons.home_rounded,
                label: 'Inicio',
              ),
              AppNavDestination(
                icon: Icons.fitness_center_outlined,
                selectedIcon: Icons.fitness_center,
                label: 'Rutinas',
              ),
              AppNavDestination(
                icon: Icons.play_arrow_rounded,
                selectedIcon: Icons.play_arrow_rounded,
                label: 'Entrenar',
              ),
              AppNavDestination(
                icon: Icons.insights_outlined,
                selectedIcon: Icons.insights,
                label: 'Progreso',
              ),
              AppNavDestination(
                icon: Icons.person_outline,
                selectedIcon: Icons.person,
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
