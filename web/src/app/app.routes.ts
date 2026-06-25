import { Routes } from '@angular/router';
import { authGuard, adminGuard, driverGuard } from './core/guards/auth.guard';

export const routes: Routes = [
  { path: '', redirectTo: '/auth/login', pathMatch: 'full' },
  {
    path: 'auth',
    children: [
      { path: 'login', loadComponent: () => import('./features/auth/login/login.component').then(m => m.LoginComponent) },
      { path: 'register', loadComponent: () => import('./features/auth/register/register.component').then(m => m.RegisterComponent) }
    ]
  },
  {
    path: 'communities',
    canActivate: [authGuard],
    children: [
      { path: '', loadComponent: () => import('./features/communities/community-list/community-list.component').then(m => m.CommunityListComponent) },
      { path: ':id', loadComponent: () => import('./features/communities/community-detail/community-detail.component').then(m => m.CommunityDetailComponent) }
    ]
  },
  {
    path: 'groups',
    canActivate: [authGuard],
    children: [
      { path: '', loadComponent: () => import('./features/groups/group-list/group-list.component').then(m => m.GroupListComponent) },
      { path: ':id', loadComponent: () => import('./features/groups/group-detail/group-detail.component').then(m => m.GroupDetailComponent) }
    ]
  },
  {
    path: 'bookings',
    canActivate: [authGuard],
    loadComponent: () => import('./features/bookings/booking-list/booking-list.component').then(m => m.BookingListComponent)
  },
  {
    path: 'tracking/:tripId',
    canActivate: [authGuard],
    loadComponent: () => import('./features/tracking/tracking-map/tracking-map.component').then(m => m.TrackingMapComponent)
  },
  {
    path: 'profile',
    canActivate: [authGuard],
    loadComponent: () => import('./features/profile/profile-page/profile-page.component').then(m => m.ProfilePageComponent)
  },
  {
    path: 'admin',
    canActivate: [authGuard, adminGuard],
    children: [
      { path: 'dashboard', loadComponent: () => import('./features/admin/dashboard/dashboard.component').then(m => m.AdminDashboardComponent) },
      { path: 'users', loadComponent: () => import('./features/admin/users/users.component').then(m => m.UsersComponent) },
      { path: 'communities', loadComponent: () => import('./features/admin/communities/communities.component').then(m => m.AdminCommunitiesComponent) }
    ]
  },
  {
    path: 'driver',
    canActivate: [authGuard, driverGuard],
    children: [
      { path: 'dashboard', loadComponent: () => import('./features/driver/dashboard/dashboard.component').then(m => m.DriverDashboardComponent) },
      { path: 'trips', loadComponent: () => import('./features/driver/trips/trips.component').then(m => m.DriverTripsComponent) }
    ]
  },
  { path: '**', redirectTo: '' }
];
