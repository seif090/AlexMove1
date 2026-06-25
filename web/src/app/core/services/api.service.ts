import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../../environments/environment';
import { ApiResponse, PaginatedResponse, Community, Group, Booking, Notification, Route } from '../models/api-response.model';

@Injectable({ providedIn: 'root' })
export class ApiService {
  private readonly baseUrl = environment.apiUrl;

  constructor(private http: HttpClient) {}

  // Auth
  getProfile(): Observable<ApiResponse<any>> {
    return this.http.get<ApiResponse<any>>(`${this.baseUrl}/users/profile`);
  }

  updateProfile(data: any): Observable<ApiResponse<any>> {
    return this.http.put<ApiResponse<any>>(`${this.baseUrl}/users/profile`, data);
  }

  // Communities
  getCommunities(page = 1, size = 10, city?: string): Observable<ApiResponse<PaginatedResponse<Community>>> {
    let params = new HttpParams().set('pageNumber', page).set('pageSize', size);
    if (city) params = params.set('city', city);
    return this.http.get<ApiResponse<PaginatedResponse<Community>>>(`${this.baseUrl}/communities`, { params });
  }

  getCommunity(id: number): Observable<ApiResponse<Community>> {
    return this.http.get<ApiResponse<Community>>(`${this.baseUrl}/communities/${id}`);
  }

  joinCommunity(communityId: number): Observable<ApiResponse<any>> {
    return this.http.post<ApiResponse<any>>(`${this.baseUrl}/communities/join`, { communityId });
  }

  getMyCommunities(): Observable<ApiResponse<Community[]>> {
    return this.http.get<ApiResponse<Community[]>>(`${this.baseUrl}/communities/my`);
  }

  // Groups
  getGroups(communityId: number, page = 1, size = 10): Observable<ApiResponse<PaginatedResponse<Group>>> {
    const params = new HttpParams().set('pageNumber', page).set('pageSize', size);
    return this.http.get<ApiResponse<PaginatedResponse<Group>>>(`${this.baseUrl}/groups/community/${communityId}`, { params });
  }

  getGroup(id: number): Observable<ApiResponse<Group>> {
    return this.http.get<ApiResponse<Group>>(`${this.baseUrl}/groups/${id}`);
  }

  searchGroups(communityId: number, query: string, page = 1, size = 10): Observable<ApiResponse<PaginatedResponse<Group>>> {
    let params = new HttpParams().set('communityId', communityId).set('pageNumber', page).set('pageSize', size);
    if (query) params = params.set('query', query);
    return this.http.get<ApiResponse<PaginatedResponse<Group>>>(`${this.baseUrl}/groups/search`, { params });
  }

  getMyGroups(): Observable<ApiResponse<Group[]>> {
    return this.http.get<ApiResponse<Group[]>>(`${this.baseUrl}/groups/my`);
  }

  // Bookings
  getMyBookings(page = 1, size = 10): Observable<ApiResponse<PaginatedResponse<Booking>>> {
    const params = new HttpParams().set('pageNumber', page).set('pageSize', size);
    return this.http.get<ApiResponse<PaginatedResponse<Booking>>>(`${this.baseUrl}/bookings/my`, { params });
  }

  createBooking(groupId: number, bookingDate: string): Observable<ApiResponse<Booking>> {
    return this.http.post<ApiResponse<Booking>>(`${this.baseUrl}/bookings`, { groupId, bookingDate });
  }

  cancelBooking(bookingId: number): Observable<ApiResponse<any>> {
    return this.http.post<ApiResponse<any>>(`${this.baseUrl}/bookings/cancel`, { bookingId });
  }

  // Routes
  getRoutes(communityId: number, page = 1, size = 10): Observable<ApiResponse<PaginatedResponse<Route>>> {
    const params = new HttpParams().set('pageNumber', page).set('pageSize', size);
    return this.http.get<ApiResponse<PaginatedResponse<Route>>>(`${this.baseUrl}/routes/community/${communityId}`, { params });
  }

  // Notifications
  getNotifications(page = 1, size = 10): Observable<ApiResponse<PaginatedResponse<Notification>>> {
    const params = new HttpParams().set('pageNumber', page).set('pageSize', size);
    return this.http.get<ApiResponse<PaginatedResponse<Notification>>>(`${this.baseUrl}/notifications`, { params });
  }

  markNotificationRead(id: number): Observable<ApiResponse<any>> {
    return this.http.post<ApiResponse<any>>(`${this.baseUrl}/notifications/${id}/read`, {});
  }

  // Dashboard
  getSuperAdminDashboard(): Observable<ApiResponse<any>> {
    return this.http.get<ApiResponse<any>>(`${this.baseUrl}/dashboard/super-admin`);
  }

  getCommunityAdminDashboard(communityId: number): Observable<ApiResponse<any>> {
    return this.http.get<ApiResponse<any>>(`${this.baseUrl}/dashboard/community-admin/${communityId}`);
  }

  getDriverDashboard(): Observable<ApiResponse<any>> {
    return this.http.get<ApiResponse<any>>(`${this.baseUrl}/dashboard/driver`);
  }
}
