using AlexandriaMobilityPlatform.Application.Common.Interfaces;
using Microsoft.Extensions.Caching.Memory;

namespace AlexandriaMobilityPlatform.Infrastructure.Caching;

public class MemoryCacheService : ICacheService
{
    private readonly IMemoryCache _cache;
    public MemoryCacheService(IMemoryCache cache) => _cache = cache;
    public Task<T?> GetAsync<T>(string key, CancellationToken cancellationToken = default) where T : class
    {
        _cache.TryGetValue(key, out T? value);
        return Task.FromResult(value);
    }
    public Task SetAsync<T>(string key, T value, TimeSpan? expiry = null, CancellationToken cancellationToken = default) where T : class
    {
        var options = new MemoryCacheEntryOptions { AbsoluteExpirationRelativeToNow = expiry ?? TimeSpan.FromMinutes(5) };
        _cache.Set(key, value, options);
        return Task.CompletedTask;
    }
    public Task RemoveAsync(string key, CancellationToken cancellationToken = default)
    {
        _cache.Remove(key);
        return Task.CompletedTask;
    }
    public Task RemoveByPrefixAsync(string prefix, CancellationToken cancellationToken = default)
    {
        return Task.CompletedTask;
    }
}
