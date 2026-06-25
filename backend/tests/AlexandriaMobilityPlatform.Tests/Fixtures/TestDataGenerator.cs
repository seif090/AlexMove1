using AlexandriaMobilityPlatform.Domain.Entities;
using AlexandriaMobilityPlatform.Domain.Enums;

namespace AlexandriaMobilityPlatform.Tests.Fixtures;

public class TestDataGenerator
{
    public static Community CreateTestCommunity(long id = 1, string name = "Test Community")
    {
        return new Community
        {
            Id = id,
            Name = name,
            Type = CommunityTypeEnum.Company,
            City = "Alexandria",
            Area = "Smouha",
            Address = "123 Main St",
            AdminId = 3,
            IsActive = true,
            CreatedAt = DateTime.UtcNow
        };
    }

    public static Route CreateTestRoute(long id = 1, long communityId = 1)
    {
        return new Route
        {
            Id = id,
            CommunityId = communityId,
            Name = "Route A",
            StartPoint = "Smouha",
            EndPoint = "San Stefano",
            StartLatitude = 31.2m,
            StartLongitude = 29.9m,
            EndLatitude = 31.25m,
            EndLongitude = 29.95m,
            DistanceKm = 12.5m,
            EstimatedTimeMinutes = 30,
            IsActive = true,
            CreatedAt = DateTime.UtcNow
        };
    }

    public static Stop CreateTestStop(long id = 1, long routeId = 1)
    {
        return new Stop
        {
            Id = id,
            RouteId = routeId,
            Name = "Stop 1",
            Latitude = 31.22m,
            Longitude = 29.92m,
            OrderNumber = 1,
            EstimatedArrivalMinutes = 5
        };
    }

    public static Group CreateTestGroup(long id = 1, long communityId = 1, long routeId = 1)
    {
        return new Group
        {
            Id = id,
            CommunityId = communityId,
            RouteId = routeId,
            DriverId = 2,
            VehicleId = 1,
            Name = "Morning Group A",
            Capacity = 10,
            AvailableSeats = 10,
            DepartureTime = new TimeSpan(8, 0, 0),
            ReturnTime = new TimeSpan(16, 0, 0),
            WorkingDays = 31,
            Status = GroupStatusEnum.Active,
            Price = 50m,
            CreatedAt = DateTime.UtcNow
        };
    }

    public static Vehicle CreateTestVehicle(long id = 1, long driverId = 2)
    {
        return new Vehicle
        {
            Id = id,
            DriverId = driverId,
            PlateNumber = "ABC-123",
            Model = "Toyota Camry",
            Color = "White",
            Capacity = 4,
            Year = 2022,
            IsActive = true,
            CreatedAt = DateTime.UtcNow
        };
    }

    public static ApplicationUser CreateTestUser(long id = 1, string email = "test@test.com")
    {
        return new ApplicationUser
        {
            Id = id,
            UserName = email,
            Email = email,
            FullName = "Test User",
            PhoneNumber = "+1234567890",
            PreferredLanguage = "en",
            IsActive = true,
            CreatedAt = DateTime.UtcNow
        };
    }

    public static ApplicationUser CreateTestDriver(long id = 2, string email = "driver@test.com")
    {
        return new ApplicationUser
        {
            Id = id,
            UserName = email,
            Email = email,
            FullName = "Test Driver",
            PhoneNumber = "+1234567891",
            PreferredLanguage = "en",
            IsActive = true,
            CreatedAt = DateTime.UtcNow
        };
    }

    public static Booking CreateTestBooking(long id = 1, long userId = 1, long groupId = 1)
    {
        return new Booking
        {
            Id = id,
            UserId = userId,
            GroupId = groupId,
            BookingDate = DateTime.Today.AddDays(1),
            Status = BookingStatusEnum.Confirmed,
            PaymentStatus = PaymentStatusEnum.Pending,
            CreatedAt = DateTime.UtcNow
        };
    }

    public static CommunityMember CreateTestCommunityMember(long id = 1, long userId = 1, long communityId = 1)
    {
        return new CommunityMember
        {
            Id = id,
            UserId = userId,
            CommunityId = communityId,
            Status = MemberStatusEnum.Approved,
            JoinedAt = DateTime.UtcNow
        };
    }

    public static CommunityAdmin CreateTestCommunityAdmin(long id = 1, long userId = 3, long communityId = 1)
    {
        return new CommunityAdmin
        {
            Id = id,
            UserId = userId,
            CommunityId = communityId,
            AddedAt = DateTimeOffset.UtcNow
        };
    }
}
