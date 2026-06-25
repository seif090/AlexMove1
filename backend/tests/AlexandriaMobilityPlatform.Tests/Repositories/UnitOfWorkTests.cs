using FluentAssertions;
using Microsoft.EntityFrameworkCore;
using AlexandriaMobilityPlatform.Infrastructure.Data;
using AlexandriaMobilityPlatform.Infrastructure.Repositories;
using AlexandriaMobilityPlatform.Tests.Fixtures;

namespace AlexandriaMobilityPlatform.Tests.Repositories;

public class UnitOfWorkTests : IDisposable
{
    private readonly ApplicationDbContext _context;
    private readonly UnitOfWork _unitOfWork;

    public UnitOfWorkTests()
    {
        var options = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;

        _context = new ApplicationDbContext(options);
        _unitOfWork = new UnitOfWork(_context);
    }

    public void Dispose()
    {
        _unitOfWork.Dispose();
    }

    [Fact]
    public void Context_Should_Return_ApplicationDbContext()
    {
        var context = _unitOfWork.Context;
        context.Should().NotBeNull();
        context.Should().BeSameAs(_context);
    }

    [Fact]
    public async Task SaveChangesAsync_Should_Persist_Changes()
    {
        var community = TestDataGenerator.CreateTestCommunity();
        await _context.Communities.AddAsync(community);
        await _unitOfWork.SaveChangesAsync();

        var result = await _context.Communities.FindAsync(community.Id);
        result.Should().NotBeNull();
    }

    [Fact]
    public async Task SaveChangesAsync_Should_Return_Number_Of_Changes()
    {
        var community = TestDataGenerator.CreateTestCommunity();
        await _context.Communities.AddAsync(community);

        var result = await _unitOfWork.SaveChangesAsync();

        result.Should().BeGreaterThanOrEqualTo(1);
    }
}
