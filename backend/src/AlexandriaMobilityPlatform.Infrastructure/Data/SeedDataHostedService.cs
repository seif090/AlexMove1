using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

namespace AlexandriaMobilityPlatform.Infrastructure.Data;

public class SeedDataHostedService : IHostedService
{
    private readonly IServiceProvider _serviceProvider;

    public SeedDataHostedService(IServiceProvider serviceProvider)
    {
        _serviceProvider = serviceProvider;
    }

    public async Task StartAsync(CancellationToken cancellationToken)
    {
        await SeedData.InitializeAsync(_serviceProvider);
    }

    public Task StopAsync(CancellationToken cancellationToken) => Task.CompletedTask;
}
