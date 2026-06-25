using AlexandriaMobilityPlatform.Application.Common.Interfaces;
namespace AlexandriaMobilityPlatform.Infrastructure.Services;
public class DateTimeService : IDateTime { public DateTimeOffset Now => DateTimeOffset.Now; public DateTimeOffset UtcNow => DateTimeOffset.UtcNow; }
