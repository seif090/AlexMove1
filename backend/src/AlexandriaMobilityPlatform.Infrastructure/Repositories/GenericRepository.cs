using System.Linq.Expressions;
using AlexandriaMobilityPlatform.Application.Interfaces.Repositories;
using AlexandriaMobilityPlatform.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace AlexandriaMobilityPlatform.Infrastructure.Repositories;

public class GenericRepository<T> : IGenericRepository<T> where T : class
{
    protected readonly ApplicationDbContext _context;
    protected readonly DbSet<T> _dbSet;
    public GenericRepository(ApplicationDbContext context) { _context = context; _dbSet = context.Set<T>(); }
    public virtual async Task<T?> GetByIdAsync(long id, CancellationToken cancellationToken = default) => await _dbSet.FindAsync(new object[] { id }, cancellationToken);
    public virtual async Task<IReadOnlyList<T>> GetAllAsync(CancellationToken cancellationToken = default) => await _dbSet.ToListAsync(cancellationToken);
    public virtual async Task<IReadOnlyList<T>> FindAsync(Expression<Func<T, bool>> predicate, CancellationToken cancellationToken = default) => await _dbSet.Where(predicate).ToListAsync(cancellationToken);
    public virtual async Task<IQueryable<T>> QueryAsync() => await Task.FromResult(_dbSet.AsQueryable());
    public virtual async Task<T> AddAsync(T entity, CancellationToken cancellationToken = default) { await _dbSet.AddAsync(entity, cancellationToken); return entity; }
    public virtual void Update(T entity) { _dbSet.Update(entity); }
    public virtual void Delete(T entity) { _dbSet.Remove(entity); }
    public virtual async Task<int> CountAsync(Expression<Func<T, bool>>? predicate = null, CancellationToken cancellationToken = default) => predicate == null ? await _dbSet.CountAsync(cancellationToken) : await _dbSet.CountAsync(predicate, cancellationToken);
    public virtual async Task<bool> AnyAsync(Expression<Func<T, bool>> predicate, CancellationToken cancellationToken = default) => await _dbSet.AnyAsync(predicate, cancellationToken);
}
