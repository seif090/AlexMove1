export interface ApiResponse<T> {
  isSuccess: boolean;
  data?: T;
  message?: string;
  errors: string[];
}

export interface PaginatedResponse<T> {
  items: T[];
  totalCount: number;
  pageNumber: number;
  totalPages: number;
  hasPreviousPage: boolean;
  hasNextPage: boolean;
}

export interface Community {
  id: number;
  name: string;
  type: string;
  city: string;
  area: string;
  address: string;
  adminName: string;
  memberCount: number;
  isActive: boolean;
  createdAt: string;
}

export interface Group {
  id: number;
  communityId: number;
  communityName: string;
  routeId: number;
  routeName: string;
  driverId: number;
  driverName: string;
  vehicleId: number;
  vehiclePlate: string;
  name: string;
  capacity: number;
  availableSeats: number;
  departureTime: string;
  returnTime?: string;
  workingDays: number;
  status: string;
  price: number;
  isSubscribed: boolean;
}

export interface Booking {
  id: number;
  userId: number;
  userName: string;
  groupId: number;
  groupName: string;
  bookingDate: string;
  status: string;
  paymentStatus: string;
  createdAt: string;
}

export interface Notification {
  id: number;
  title: string;
  message: string;
  type: string;
  isRead: boolean;
  createdAt: string;
}

export interface Route {
  id: number;
  communityId: number;
  communityName: string;
  name: string;
  startPoint: string;
  endPoint: string;
  distanceKm: number;
  estimatedTimeMinutes: number;
  stops: Stop[];
  isActive: boolean;
}

export interface Stop {
  id: number;
  name: string;
  latitude: number;
  longitude: number;
  orderNumber: number;
  estimatedArrivalMinutes: number;
}

export interface Vehicle {
  id: number;
  driverId: number;
  driverName: string;
  plateNumber: string;
  model: string;
  color: string;
  capacity: number;
  year: number;
  isActive: boolean;
}
