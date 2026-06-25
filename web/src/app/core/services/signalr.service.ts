import { Injectable, signal } from '@angular/core';
import * as signalR from '@microsoft/signalr';
import { environment } from '../../../environments/environment';
import { AuthService } from './auth.service';

@Injectable({ providedIn: 'root' })
export class SignalRService {
  private trackingConnection!: signalR.HubConnection;
  private notificationConnection!: signalR.HubConnection;
  driverLocation = signal<{ latitude: number; longitude: number } | null>(null);
  tripStatus = signal<string>('');
  newNotification = signal<any>(null);

  constructor(private authService: AuthService) {}

  startTrackingConnection(): void {
    const token = this.authService.getToken();
    this.trackingConnection = new signalR.HubConnectionBuilder()
      .withUrl(`${environment.signalRUrl}/tracking`, { accessTokenFactory: () => token || '' })
      .withAutomaticReconnect()
      .build();

    this.trackingConnection.on('ReceiveDriverLocation', (data: any) => {
      this.driverLocation.set({ latitude: data.latitude, longitude: data.longitude });
    });

    this.trackingConnection.on('ReceiveTripStatus', (data: any) => {
      this.tripStatus.set(data.status);
    });

    this.trackingConnection.start().catch(err => console.error('Tracking connection error:', err));
  }

  startNotificationConnection(): void {
    const token = this.authService.getToken();
    this.notificationConnection = new signalR.HubConnectionBuilder()
      .withUrl(`${environment.signalRUrl}/notifications`, { accessTokenFactory: () => token || '' })
      .withAutomaticReconnect()
      .build();

    this.notificationConnection.on('ReceiveNotification', (data: any) => {
      this.newNotification.set(data);
    });

    this.notificationConnection.start().catch(err => console.error('Notification connection error:', err));
  }

  joinTripGroup(tripId: number): void {
    this.trackingConnection?.invoke('JoinTripGroup', tripId);
  }

  updateDriverLocation(tripId: number, lat: number, lng: number): void {
    this.trackingConnection?.invoke('UpdateDriverLocation', tripId, lat, lng, null);
  }

  stopAll(): void {
    this.trackingConnection?.stop();
    this.notificationConnection?.stop();
  }
}
