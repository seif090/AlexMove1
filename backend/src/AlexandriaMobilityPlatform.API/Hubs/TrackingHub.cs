using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.SignalR;

namespace AlexandriaMobilityPlatform.API.Hubs;

[Authorize]
public class TrackingHub : Hub
{
    private readonly ILogger<TrackingHub> _logger;
    public TrackingHub(ILogger<TrackingHub> logger) => _logger = logger;

    public async Task JoinTripGroup(long tripId)
    {
        await Groups.AddToGroupAsync(Context.ConnectionId, $"trip_{tripId}");
        _logger.LogInformation("User {UserId} joined trip group {TripId}", Context.User?.Identity?.Name, tripId);
    }

    public async Task LeaveTripGroup(long tripId)
    {
        await Groups.RemoveFromGroupAsync(Context.ConnectionId, $"trip_{tripId}");
    }

    public async Task UpdateDriverLocation(long tripId, decimal latitude, decimal longitude, decimal? accuracy)
    {
        await Clients.Group($"trip_{tripId}").SendAsync("ReceiveDriverLocation", new
        {
            tripId,
            latitude,
            longitude,
            accuracy,
            timestamp = DateTime.UtcNow
        });
    }

    public async Task UpdateTripStatus(long tripId, string status)
    {
        await Clients.Group($"trip_{tripId}").SendAsync("ReceiveTripStatus", new { tripId, status, timestamp = DateTime.UtcNow });
    }

    public override async Task OnConnectedAsync()
    {
        _logger.LogInformation("Client connected: {ConnectionId}", Context.ConnectionId);
        await base.OnConnectedAsync();
    }

    public override async Task OnDisconnectedAsync(Exception? exception)
    {
        _logger.LogInformation("Client disconnected: {ConnectionId}", Context.ConnectionId);
        await base.OnDisconnectedAsync(exception);
    }
}
