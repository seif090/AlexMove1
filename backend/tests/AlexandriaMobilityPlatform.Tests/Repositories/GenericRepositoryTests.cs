using FluentAssertions;
using Microsoft.EntityFrameworkCore;
using AlexandriaMobilityPlatform.Infrastructure.Data;
using AlexandriaMobilityPlatform.Infrastructure.Repositories;
using AlexandriaMobilityPlatform.Tests.Fixtures;
using AlexandriaMobilityPlatform.Domain.Entities;

namespace AlexandriaMobilityPlatform.Tests.Repositories;

public class GenericRepositoryTests : IDisposable
{
    private readonly ApplicationDbContext _context;
    private readonly GenericRepository<Community> _repository;

    public GenericRepositoryTests()
    {
        var options = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;

        _context = new ApplicationDbContext(options);
        _repository = new GenericRepository<Community>(_context);
    }

    public void Dispose()
    {
        _context.Dispose();
    }

    [Fact]
    public async Task GetByIdAsync_Should_Return_Entity()
    {
        var community = TestDataGenerator.CreateTestCommunity();
        _context.Communities.Add(community);
        await _context.SaveChangesAsync();

        var result = await _repository.GetByIdAsync(1);

        result.Should().NotBeNull();
        result!.Name.Should().Be("Test Community");
    }

    [Fact]
    public async Task GetByIdAsync_Should_Return_Null_When_Not_Found()
    {
        var result = await _repository.GetByIdAsync(999);
        result.Should().BeNull();
    }

    [Fact]
    public async Task GetAllAsync_Should_Return_All_Entities()
    {
        _context.Communities.Add(TestDataGenerator.CreateTestCommunity(1, "Community 1"));
        _context.Communities.Add(TestDataGenerator.CreateTestCommunity(2, "Community 2"));
        await _context.SaveChangesAsync();

        var result = await _repository.GetAllAsync();

        result.Should().HaveCount(2);
    }

    [Fact]
    public async Task AddAsync_Should_Add_Entity()
    {
        var community = TestDataGenerator.CreateTestCommunity();

        await _repository.AddAsync(community);
        await _context.SaveChangesAsync();

        var result = await _context.Communities.FindAsync(community.Id);
        result.Should().NotBeNull();
    }

    [Fact]
    public void Update_Should_Update_Entity()
    {
        var community = TestDataGenerator.CreateTestCommunity();
        _context.Communities.Add(community);
        _context.SaveChanges();

        community.Name = "Updated Community";
        _repository.Update(community);
        _context.SaveChanges();

        var result = _context.Communities.Find(community.Id);
        result!.Name.Should().Be("Updated Community");
    }

    [Fact]
    public void Delete_Should_Remove_Entity()
    {
        var community = TestDataGenerator.CreateTestCommunity();
        _context.Communities.Add(community);
        _context.SaveChanges();

        _repository.Delete(community);
        _context.SaveChanges();

        var result = _context.Communities.Find(community.Id);
        result.Should().BeNull();
    }

    [Fact]
    public async Task FindAsync_Should_Return_Matching_Entities()
    {
        _context.Communities.Add(TestDataGenerator.CreateTestCommunity(1, "Active Community"));
        _context.Communities.Add(TestDataGenerator.CreateTestCommunity(2, "Inactive Community"));
        await _context.SaveChangesAsync();

        var result = await _repository.FindAsync(c => c.Name.Contains("Active"));

        result.Should().HaveCount(1);
    }

    [Fact]
    public async Task FirstOrDefaultAsync_Should_Return_First_Match()
    {
        _context.Communities.Add(TestDataGenerator.CreateTestCommunity(1, "First"));
        _context.Communities.Add(TestDataGenerator.CreateTestCommunity(2, "Second"));
        await _context.SaveChangesAsync();

        var result = await _repository.QueryAsync();
        var first = await result.FirstOrDefaultAsync(c => c.Name == "First");

        first.Should().NotBeNull();
        first!.Name.Should().Be("First");
    }

    [Fact]
    public async Task AnyAsync_Should_Return_True_When_Exists()
    {
        _context.Communities.Add(TestDataGenerator.CreateTestCommunity());
        await _context.SaveChangesAsync();

        var result = await _repository.AnyAsync(c => c.Name == "Test Community");

        result.Should().BeTrue();
    }

    [Fact]
    public async Task AnyAsync_Should_Return_False_When_Not_Exists()
    {
        var result = await _repository.AnyAsync(c => c.Name == "Non-existent");

        result.Should().BeFalse();
    }

    [Fact]
    public async Task CountAsync_Should_Return_Correct_Count()
    {
        _context.Communities.Add(TestDataGenerator.CreateTestCommunity(1, "C1"));
        _context.Communities.Add(TestDataGenerator.CreateTestCommunity(2, "C2"));
        _context.Communities.Add(TestDataGenerator.CreateTestCommunity(3, "C3"));
        await _context.SaveChangesAsync();

        var result = await _repository.CountAsync();

        result.Should().Be(3);
    }
}
