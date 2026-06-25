using FluentAssertions;
using AlexandriaMobilityPlatform.Tests.Fixtures;
using AlexandriaMobilityPlatform.Domain.Entities;
using AlexandriaMobilityPlatform.Domain.Enums;

namespace AlexandriaMobilityPlatform.Tests.Domain;

public class EntityTests
{
    [Fact]
    public void Community_Should_Have_Default_Values()
    {
        var community = new Community();
        community.IsActive.Should().BeTrue();
        community.LogoUrl.Should().BeNull();
    }

    [Fact]
    public void Group_Should_Have_Correct_Defaults()
    {
        var group = new Group();
        group.Status.Should().Be(GroupStatusEnum.Active);
        group.AvailableSeats.Should().Be(0);
    }

    [Fact]
    public void Booking_Should_Have_Correct_Defaults()
    {
        var booking = new Booking();
        booking.Status.Should().Be(BookingStatusEnum.Confirmed);
        booking.PaymentStatus.Should().Be(PaymentStatusEnum.Pending);
    }

    [Fact]
    public void Route_Should_Have_Correct_Defaults()
    {
        var route = new Route();
        route.IsActive.Should().BeTrue();
    }

    [Fact]
    public void Vehicle_Should_Have_Correct_Defaults()
    {
        var vehicle = new Vehicle();
        vehicle.IsActive.Should().BeTrue();
        vehicle.Status.Should().Be(VehicleStatusEnum.Active);
    }

    [Fact]
    public void Stop_Should_Be_Created_With_Correct_Values()
    {
        var stop = TestDataGenerator.CreateTestStop();
        stop.Name.Should().Be("Stop 1");
        stop.OrderNumber.Should().Be(1);
        stop.EstimatedArrivalMinutes.Should().Be(5);
    }

    [Fact]
    public void Community_Should_Be_Created_With_Correct_Values()
    {
        var community = TestDataGenerator.CreateTestCommunity();
        community.Name.Should().Be("Test Community");
        community.City.Should().Be("Alexandria");
        community.Area.Should().Be("Smouha");
        community.IsActive.Should().BeTrue();
    }

    [Fact]
    public void Group_Should_Be_Created_With_Correct_Values()
    {
        var group = TestDataGenerator.CreateTestGroup();
        group.Name.Should().Be("Morning Group A");
        group.Capacity.Should().Be(10);
        group.Price.Should().Be(50m);
        group.DepartureTime.Should().Be(new TimeSpan(8, 0, 0));
        group.ReturnTime.Should().Be(new TimeSpan(16, 0, 0));
    }

    [Fact]
    public void Booking_Should_Be_Created_With_Correct_Values()
    {
        var booking = TestDataGenerator.CreateTestBooking();
        booking.BookingDate.Should().Be(DateTime.Today.AddDays(1));
        booking.Status.Should().Be(BookingStatusEnum.Confirmed);
        booking.PaymentStatus.Should().Be(PaymentStatusEnum.Pending);
    }

    [Fact]
    public void Vehicle_Should_Be_Created_With_Correct_Values()
    {
        var vehicle = TestDataGenerator.CreateTestVehicle();
        vehicle.PlateNumber.Should().Be("ABC-123");
        vehicle.Model.Should().Be("Toyota Camry");
        vehicle.Capacity.Should().Be(4);
        vehicle.Year.Should().Be(2022);
    }

    [Fact]
    public void Route_Should_Be_Created_With_Correct_Values()
    {
        var route = TestDataGenerator.CreateTestRoute();
        route.Name.Should().Be("Route A");
        route.StartPoint.Should().Be("Smouha");
        route.EndPoint.Should().Be("San Stefano");
        route.DistanceKm.Should().Be(12.5m);
        route.EstimatedTimeMinutes.Should().Be(30);
    }

    [Fact]
    public void ApplicationUser_Should_Be_Created_With_Correct_Values()
    {
        var user = TestDataGenerator.CreateTestUser();
        user.FullName.Should().Be("Test User");
        user.Email.Should().Be("test@test.com");
        user.PreferredLanguage.Should().Be("en");
        user.IsActive.Should().BeTrue();
    }

    [Fact]
    public void Notification_Should_Have_Default_Values()
    {
        var notification = new Notification();
        notification.IsRead.Should().BeFalse();
    }

    [Fact]
    public void DriverLocation_Should_Be_Created_With_Correct_Values()
    {
        var location = new DriverLocation
        {
            DriverId = 2,
            TripId = 1,
            Latitude = 31.2m,
            Longitude = 29.9m,
            AccuracyMeters = 10m,
            RecordedAt = DateTime.UtcNow
        };
        location.Latitude.Should().Be(31.2m);
        location.Longitude.Should().Be(29.9m);
        location.AccuracyMeters.Should().Be(10m);
    }

    [Fact]
    public void Payment_Should_Have_Default_Values()
    {
        var payment = new Payment();
        payment.Status.Should().Be(PaymentStatusEnum.Pending);
    }

    [Fact]
    public void Trip_Should_Have_Default_Values()
    {
        var trip = new Trip();
        trip.Status.Should().Be(TripStatusEnum.Scheduled);
    }
}
