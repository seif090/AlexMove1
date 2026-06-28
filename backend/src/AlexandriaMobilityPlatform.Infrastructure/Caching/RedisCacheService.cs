using AlexandriaMobilityPlatform.Application.Common.Interfaces;
using Microsoft.Extensions.Caching.Distributed;
using System.Text.Json;

namespace AlexandriaMobilityPlatform.Infrastructure.Caching;

public class RedisCacheService : ICacheService
{
    private readonly IDistributedCache _cache;

    public RedisCacheService(IDistributedCache cache) => _cache = cache;

    public async Task<T?> GetAsync<T>(string key, CancellationToken cancellationToken = default) where T : class
    {
        var cached = await _cache.GetStringAsync(key, cancellationToken);
        return cached is null ? null : JsonSerializer.Deserialize<T>(cached);
    }

    public async Task SetAsync<T>(string key, T value, TimeSpan? expiry = null, CancellationToken cancellationToken = default) where T : class
    {
        var options = new DistributedCacheEntryOptions
        {
            AbsoluteExpirationRelativeToNow = expiry ?? TimeSpan.FromMinutes(5)
        };
        await _cache.SetStringAsync(key, JsonSerializer.Serialize(value), options, cancellationToken);
    }

    public async Task RemoveAsync(string key, CancellationToken cancellationToken = default)
    {
        await _cache.RemoveAsync(key, cancellationToken);
    }

    public async Task RemoveByPrefixAsync(string prefix, CancellationToken cancellationToken = default)
    {
        try
        {
            if (_cache is StackExchange.Redis.IDatabase redisDb)
            {
                var server = redisDb.Multiplexer.GetServer(redisDb.Multiplexer.GetEndPoints().First());
                var keys = server.Keys(pattern: $"{prefix}*");
                foreach (var key in keys)
                {
                    await _cache.RemoveAsync(key.ToString(), cancellationToken);
                }
            }
            else
            {
                await Task.CompletedTask;
            }
        }
        catch
        {
            await Task.CompletedTask;
        }
    }
}
